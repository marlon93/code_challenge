ActiveRecord::Base.transaction do
  user = User.create!(
    email: 'maup1993@gmail.com',
    password: '12345678Mm*',
    password_confirmation: '12345678Mm*'
  )

  puts "User created successfully: #{user.email}"
rescue ActiveRecord::RecordInvalid => e
  puts "User creation failed: #{e.message}"
end
