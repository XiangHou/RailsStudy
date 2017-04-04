task :task_one do
  puts "This is Task One!"
end

namespace :namespace do
  desc "Task with namespace"
  task :task_two do
    puts "This is Task Two"
  end

  desc "The third task"
  task :task_three => :task_one do
    puts "This is Task Three"
  end

  desc "The fourth task"
  task :task_four => [:task_one, :task_two] do
    puts "This is Task Four"
  end

  desc "The fifth task"
  task :task_five do
    Rake::Task['namespace:task_three'].invoke
    puts "This is task five!"
  end

  desc "The task related environment, tell Rake to load full the application environment"
  task :task_six => :environment do
    puts "This is task six"
  end
end


task :all => [:task_one, 'namespace:task_two', 'namespace:task_three', 'namespace:task_four', 'namespace:task_five', 'namespace:task_six']