namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    100.times do |n|
      name = "example-#{n+1}"
      email = "example-#{n+1}@gmail.com"
      password = "forever"
      password_confirmation = "forever"
      if(n%2 == 1)
	is_student = true
	gender = false
      else is_student = false
	gender = true
      end
      district_id = n%3
      description = "description"
      visible = true
      degree_id = (n+1)%3
      
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password,
		   is_student: is_student,
		   gender: gender,
		   district_id: district_id,
		   description: description,
		   visible: visible,
		   degree_id: degree_id)

      
    end
  end
end

