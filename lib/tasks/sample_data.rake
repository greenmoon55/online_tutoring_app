namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    100.times do |n|
      name = "example-#{n+1}"
      email = "example-#{n+1}@gmail.com"
      password = "forever"
      password_confirmation = "forever"
      if(n%2 == 1)
	role = 1
	if(n%4 == 1)
	  gender = 1
	else
	  gender = 0
	end
      else 
	role = 0
	if(n%4 == 0)
	  gender = 1
	else
	  gender = 0
	end
      end
      district_id = n%18
      description = "description"
      visible = true
      degree_id = n%6
      
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password,
		   role: role,
		   gender: gender,
		   district_id: district_id,
		   description: description,
		   visible: visible,
		   degree_id: degree_id)

      
    end
  end
end

