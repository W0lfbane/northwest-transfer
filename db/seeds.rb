# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.delete_all
Role.delete_all
Project.delete_all
Group.delete_all


5.times do |i|
    User.create!( email: "user-#{i}@paulsens.com", password: "password-#{i}", password_confirmation: "password-#{i}" )
    
    Project.create!( title: "Project ##{i}", 
                   description: "This is a project.", 
                   location: "Here!",
                   start_date: Time.now + i.weeks,
                   estimated_time: Time.new(0) + i.minutes + i.hours )
                   
    Group.create!( name: "group-#{i}",
                    address: "#{i} Parkway Ln",
                    phone: "#{i}-666-666-6666" )
end

Project.all.each do |project|
    5.times do |i|
        project.users << User.find(i + 1)
        project.tasks.create!(name: "Task ##{i}", description: "This is task ##{i} on #{project.title}.")
    end
end

Group.all.each_with_index do |group, index|
   group.users  << User.find(index + 1)
   group.projects << Project.find(index + 1)
end
