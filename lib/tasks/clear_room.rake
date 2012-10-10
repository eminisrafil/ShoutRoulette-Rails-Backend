

desc "Clears out all active rooms"
  task :clear => :environment do
    Room.destroy_all
    puts "all rooms cleared"
  end