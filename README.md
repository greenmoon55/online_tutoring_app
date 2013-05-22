online_tutoring_app
===================

专业方向综合项目

代码规范
-------

所有 HTML/CSS/JavaScript、Ruby 代码均采用两个空格缩进，不用tab...

配置说明
-------

> bundle install --without production # 安装需要的 gem

> bundle exec rake db:migrate # 迁移数据库

> rackup private_pub.ru -s thin -E production # 运行聊天服务器

> 运行redis，参考 README。http://redis.io # 这个数据库用来保存在线用户

> 第一次运行时执行 bundle exec rake db:seed 载入设置好的数据，以后应该就不用了。
