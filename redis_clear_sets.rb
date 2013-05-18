# encoding: utf-8
require 'redis'
now = Time.now.to_i
redis = Redis.new
#删除十分钟以上的记录
(0...60).each do |x|
  redis.del(x) if ((x + 10) % 60 > now)
end
