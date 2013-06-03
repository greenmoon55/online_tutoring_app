本文档定义服务器传来的消息的格式
=========

1. 私聊消息
--------

```json
{
  "message": {
    "id": 1,
    "content": "消息内容", 
    "created_at": "2013-05-29 15:55:18",
    "sender_name": "greenmoon55",
    "sender_id": 121,
    "read": true
  }, 
  "type": 1
}
```

2. 移除用户
--------

```json
{
  "type": 2,
  "user_id": 101
}
```

3. 添加用户
--------

```json
{
  "type": 3, 
  "user": {
    "id": 111, 
    "name": "greenmoon55", 
    "online": true
  }
}
```

4. 群聊消息
--------

```json
{
  "type": 4,
  "message": {
    "content": "hello world",
    "created_at": "2013-05-29 15:55:18",
    "sender_id": 102,
    "sender_name": "greenmoon55" 
  },
  "room_id": 5
}
