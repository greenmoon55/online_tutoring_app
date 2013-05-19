# encoding: utf-8
require 'redis'
now = Time.now.strftime("%M").to_i
p now
redis = Redis.new
#删除两分钟以上的记录
(0...60).each do |x|
#  redis.del(x) if ((x + 2) % 60 > now)
  if ((x + 2) % 60 > now)
    puts x
    redis.del(x)
  end
end
