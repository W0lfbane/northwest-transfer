# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.destroy_all
Role.destroy_all
Project.destroy_all
Group.destroy_all


["customer", "employee", "admin"].each do |role|
    Role.create!(name: role)
end

20.times do |i|
    User.create!( email: "user-#{i}@paulsens.com", password: "password-#{i}", password_confirmation: "password-#{i}" )
end

5.times do |i|
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
    project.users << User.all.sample(5)

    5.times do |i|
        project.tasks.create!(name: "Task ##{i}", description: "This is task ##{i} on #{project.title}.")
    end
end

Group.all.each do |group|
   group.users  << User.all.sample(5)
   group.projects << Project.all.sample(5)
end

User.all.each do |user|
    user.add_role(Role.pluck(:name).sample)

    resource_roles = { project: ["customer", "employee", "operator"], 
                       group: ["customer", "employee", "moderator", "admin"] }

    resource_roles.each do |resource, roles|
        applied_resource = resource.to_s.capitalize.constantize

        user.add_role(roles.sample, applied_resource.offset(rand(applied_resource.count)).first)
    end
end
