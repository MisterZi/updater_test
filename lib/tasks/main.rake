namespace :main do
  desc 'Users shard_id updater'
  task :update_shard_id, [:max_db_connections] => :environment do |taskname, args|

    max_threads = args.max_db_connections.to_i > 0 ? args.max_db_connections.to_i : 4

    empty_shard_id_count = User.empty_shard_id_list.count
    failed_users = [0]
    fail_count = 0
    update_count = 0
    task_start_time = Time.now
    running_time = 0

    loop do
      users = User.not_include(User.empty_shard_id_list, failed_users)
      if users.empty?
        print "\nDONE! Run time: #{humanize_time(Time.now - task_start_time)}\n"
        break
      end
      threads = []

      users.each do |user|
        threads << Thread.new do
          begin
            user.shard_id = rand(1..10)
            user.save!
            update_count += 1
          rescue
            fail_count += 1
            failed_users << user.id
          end
        end
        break if threads.count >= max_threads
      end

      start_threads_time = Time.now
      threads.each(&:join)
      running_time += (Time.now - start_threads_time)
      time_remaining = running_time / (update_count + fail_count) * users.count

      print "\rAll: #{empty_shard_id_count}; Updated: #{update_count}; Failed: #{fail_count}; Average remaining time: #{humanize_time(time_remaining)}"
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