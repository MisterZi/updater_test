namespace :main do
  task update_shard_id!: :environment do |taskname|
    empty_shard_id_count = User.empty_shard_id_list.count
    fail_count = 0
    update_count = 0
    running_time = 0

    loop do
      users = User.empty_shard_id_list
      if users.empty?
        puts "DONE! All: #{empty_shard_id_count}; Updated: #{update_count}; Failed: #{fail_count}"
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
            print "Failed: #{e.message}. Cant update user № #{user.id}!\n"
          end
        end
        break if threads.count > 8
      end
      start_threads_time = Time.now
      threads.each do |t|
        t.join
      end
      running_time += (Time.now - start_threads_time)
      time_remaining = running_time / (update_count + fail_count) * (users.count / threads.count)
      print "Average remaining time: #{time_remaining.round(2)}\n"
    end
  end
end