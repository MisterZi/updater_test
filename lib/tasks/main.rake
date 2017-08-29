namespace :main do
  task update_shard_id!: :environment do |taskname|

    MAX_THREADS = 29

    empty_shard_id_count = User.empty_shard_id_list.count
    fail_count = 0
    update_count = 0
    task_start_time = Time.now
    running_time = 0

    loop do
      users = User.empty_shard_id_list
      if users.empty?
        puts "DONE! All: #{empty_shard_id_count}; Updated: #{update_count}; Failed: #{fail_count}; Run time: #{humanize_time(Time.now - task_start_time)}"
        break
      end
      threads = []
      users.each do |user|
        threads << Thread.new do
          begin
            user.shard_id = nil
            user.save!
            update_count += 1
          rescue Exception => e
            fail_count += 1
          end
        end
        break if threads.count >= MAX_THREADS
      end
      start_threads_time = Time.now
      threads.each do |t|
        t.join
      end
      running_time += (Time.now - start_threads_time)
      time_remaining = running_time / (update_count + fail_count) * users.count
      print "Average remaining time: #{humanize_time(time_remaining)}\r"
      print "Average remaining time: #{humanize_time(time_remaining)}. HAVE SOME FAILED UPDATE!\r" if fail_count > 0
    end
  end

  def humanize_time(secs)
    [[60, :seconds], [60, :minutes], [24, :hours], [1000, :days]].map{ |count, name|
      if secs > 0
        secs, n = secs.divmod(count)
        "#{n.to_i} #{name}"
      end
    }.compact.reverse.join(' ')
  end

end