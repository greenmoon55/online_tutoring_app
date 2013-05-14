namespace :db do
  desc "Fill database with sample data"
  task full_subject: :environment do
    subject = ["语文","数学","英语","物理","化学","生物","历史","地理","政治"]
    n = 0
    9.times do
      Subject.create!(name: subject[n])
      n = n + 1
    end

  end
end
