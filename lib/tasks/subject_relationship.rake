namespace :db do
  desc "Fill database with sample data"
  task daijia: :environment do
    n = 2
    50.times do 
    User.find(n).student_relationships.create!(subject_id: n%9+1)
    User.find(n).student_relationships.create!(subject_id: (n+1)%9+1)
    User.find(n).student_relationships.create!(subject_id: (n+2)%9+1)
    User.find(n).student_relationships.create!(subject_id: (n+3)%9+1)
    n = n + 2
    end
    n = 1
    50.times do 
    User.find(n).teacher_relationships.create!(subject_id: (n+4)%9+1)
    User.find(n).teacher_relationships.create!(subject_id: (n+5)%9+1)
    User.find(n).teacher_relationships.create!(subject_id: (n+6)%9+1)
    User.find(n).teacher_relationships.create!(subject_id: (n+7)%9+1)
    n = n + 2
    end
  end
end

