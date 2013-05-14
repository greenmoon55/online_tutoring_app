namespace :db do
  desc "Fill database with sample data"
  task full_degree_district: :environment do
    degree = ["小学","初中","高中","本科","硕士","博士"]
    n = 0
    6.times do
      Degree.create!(id: n, name: degree[n])
      n = n + 1
    end
district = ["黄浦区","卢湾区","长宁区","普陀区","虹口区","闵行区","徐汇区","匣北区","杨浦区","静安区","嘉定区","宝山区","青浦区","松江区","金山区", "奉贤区", "崇明县","浦东新区"]
    n = 0
    18.times do
      District.create!(id: n, name: district[n])
      n = n + 1
    end
  end
end

