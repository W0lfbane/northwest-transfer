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

resource_interval = 100
resource_roles = { user: ["customer", "employee", "admin"],
                    project: ["customer", "employee", "leader"], 
                    group: ["customer", "employee", "moderator", "admin"] }

admin_user = User.create!( email: "test@test.com", password: "password123", first_name: "Admin", last_name: "Admin", phone: "666-666-6666" )

resource_roles[:user].each do |role|
    Role.create!(name: role)
    admin_user.add_role(role)
end

resource_interval.times do |i|
    user = User.new( email: Faker::Internet.email, 
                        password: Faker::Internet.password, 
                        first_name: Faker::Name.first_name, 
                        last_name: Faker::Name.last_name,
                        phone: Faker::PhoneNumber.phone_number)
    user.save!
    user.add_role resource_roles[:user].sample
end

resource_interval.times do |i|
    start_date = Faker::Date.between(Date.today, i.days.from_now)
    Project.create!( title: Faker::Company.name, 
                   description: Faker::Lorem.paragraph,
                   address: Faker::Address.street_address,
                   city: Faker::Address.city,
                   state: Faker::Address.state,
                   postal: Faker::Address.postcode,
                   start_date: start_date,
                   estimated_completion_date: Faker::Date.between(start_date, start_date + (i + i).days) )
end

Project.all.each do |project|
    users = User.all.sample(5)
    project.users << users

    5.times do |i|
        project.tasks.create!(name: "Task ##{i}", description: "This is task ##{i} on #{project.title}.")
    end
end

resource_roles.each do |resource, roles|
    unless resource == :user
        klass = resource.to_s.capitalize.constantize
        
        ObjectSpace.each_object(klass) do |object| 
            users = object.users
            users.each { |user| user.add_role(roles.sample, object) }
        end
    end
end