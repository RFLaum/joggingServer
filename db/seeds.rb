User.create(username: "russell", password: "password",
            password_confirmation: "password", role: "admin")
User.create(username: "manager", password: "password",
            password_confirmation: "password", role: "manager")
50.times do
  User.create(username: Faker::Internet.unique.user_name, password: "password",
              password_confirmation: "password", role: "user")
end

User.all.each do |user|
  90.times do
    Jog.create(user: user, date: Faker::Date.backward(30*7),
               time: Faker::Number.between(20, 2*60*60),
               distance: Faker::Number.between(10, 200)/10.0)
  end
end
