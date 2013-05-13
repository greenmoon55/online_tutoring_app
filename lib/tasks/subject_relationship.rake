namespace :db do
  desc "Fill database with sample data"
  task full_subject: :environment do
    n = 2
    50.times do 
    User.find(n).student_relationships.create!(subject_id: n%9+1)
    User.find(n).student_relationships.create!(subject_id: n%9+2)
    User.find(n).student_relationships.create!(subject_id: n%9+3)
    User.find(n).student_relationships.create!(subject_id: n%9+4)
    n = n + 2
    end
    n = 1
    50.times do 
    User.find(n).teacher_relationships.create!(subject_id: n%9+5)
    User.find(n).teacher_relationships.create!(subject_id: n%9+6)
    User.find(n).teacher_relationships.create!(subject_id: n%9+7)
    User.find(n).teacher_relationships.create!(subject_id: n%9+8)
    n = n + 2
    end
  end
end

