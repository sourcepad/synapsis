def create_user
  user_email = Faker::Internet.email[0, 29] # Limit 30 characters

  user_params = {
    email: user_email,
    fullname: user_email,
    phonenumber: Faker::PhoneNumber.phone_number,
    password: '5ourcep4d',
    ip_address: '8.8.8.8'
  }

  return Synapsis::User.create(user_params)
end

