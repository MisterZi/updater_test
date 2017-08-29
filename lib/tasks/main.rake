namespace :main do
  task update_shard_id!: :environment do |taskname|
    threads = []
    empty_shard_id_count = User.empty_shard_id_list.count
    fail_count = 0
    update_count = 0

    loop do
      users = User.empty_shard_id_list
      if users.empty?
        puts "DONE! All: #{empty_shard_id_count}; Updated: #{update_count}; Failed: #{fail_count}"
        break
      end
      users.each do |user|
        threads << Thread.new do
          begin
            user.shard_id = rand(1..10)
            user.save!
            update_count += 1
            print "User № #{user.id} updated!\n"
          rescue Exception => e
            fail_count += 1
            print "Failed: #{e.message}. Cant update user № #{user.id}!\n"
          end
        end
        break if threads.count > 8
      end
      threads.each(&:join)
    end
  end
end