online_tutoring_app
===================

专业方向综合项目

代码规范
-------

所有 HTML/CSS/JavaScript、Ruby 代码均采用两个空格缩进，不用tab...

下面两个供参考

* [Ruby 编程风格](http://ruby-china.org/wiki/coding-style)
* [Code Conventions for the JavaScript Programming Language](Code Conventions for the JavaScript Programming Language)

配置说明
-------

> bundle install --without production # 安装需要的 gem

> bundle exec rake db:migrate # 迁移数据库

> rackup private_pub.ru -s thin -E production # 运行聊天服务器

> 运行redis，参考 README。http://redis.io # 这个数据库用来保存在线用户

> 第一次运行时执行 bundle exec rake db:seed 载入设置好的数据，以后应该就不用了。


消息格式
-------

见 doc/message_format.md

Redis 的作用
-------

sorted set: key: online-users, score: timestamp, member: uid

按 score 排序

ZADD O(log(N))
ZCARD get score by member O(1) 获取用户最后刷新时间
