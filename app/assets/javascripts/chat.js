var chatOpened = false; // 聊天窗口是否被打开过
var userList = [];
var currentUid;
$(document).ready(function() {
  $("#chat-popup-button").click(function() {
    if (!chatOpened) {
      $("#chat-box").show();
      getUserList();
      chatOpened = true;
    } else {
      $("#chat-box").toggle();
    }
  });

  $("#chat-close").click(function() {
    $("#chat-box").hide();
    return false;
  });

  $("#chat-left").on("click", "li", function() {
    activateItem(this);
  });

  $("#chat-with-button").click(function() {
    var path = window.location.pathname;
    var uid = path.match(/\/users\/(\d*)/)[1]; // 需要修改
    currentUid = parseInt(uid);
    var username = $("#username").text();
    var isOnline = $("#img_online").length;
    if (!chatOpened) {
      getUserList();
      chatOpened = true;
    }
    $("#chat-box").show();
    if (!userExists(uid)) addUser(uid, username, isOnline);
    activateUser(uid);
  });

  $("#chat-sendbutton").click(function() {
    $("#new_message").submit();
    $("#message_content").val("");
    return false;
  });

  $("#new_message").on("submit", function() {
    console.log($(this).serialize());
    $.ajax({
      url: $(this).prop("action"),
      type: "POST",
      data: $(this).serialize()
    })
    return false;
  });
});

function userExists(uid) {
  var str = "#chat-left li#" + uid;
  // 判断是否已存在该用户
  return $(str).length;
}

function getUserList() {
  if ($.cookie("userList")) {
    userList = JSON.parse($.cookie("userList"));

    for (var i = 0; i < userList.length; i++) {
      addUserToList(userList[i]["id"], userList[i]["name"], false);
    }

    var uids = [];
    for (var i = 0; i < userList.length; i++) {
      uids.push(parseInt(userList[i]["id"])); 
    }
    getConversations(uids);
  }
}

function getConversations(uids) {
  console.log("getconversations");
  console.log(JSON.stringify({"users": uids}));
  $.ajax({
    url: "http://localhost:3000/chat/messages/",
    type: "GET",
    dataType: "json",
    data: {"users": uids}
  }).success(function(data) {
    console.log(data);
    for (var j = 0; j < data.length; j++) {
      onChatMessage(data[j]);
    }
    if (currentUid) {
      activateUser(currentUid);
    }
  });
}

function getConversation(uid) {
  $.ajax({
    url: "http://localhost:3000/chat/messages/"+uid,
    type: "GET",
    dataType: "json"
  }).success(function(data) {
    console.log(data);
    for (var j = 0; j < data.length; j++) {
      onChatMessage(data[j]);
    }
    if (currentUid) {
      activateUser(currentUid);
    }
  });
}

// 仅把用户添加到用户列表中显示
function addUserToList(uid, username, isOnline) {
  console.log("addUserToList");
  str = "#chat-left li#" + uid;
  // 判断是否已存在该用户
  if (!$(str).length) {
    var statusSpan = document.createElement("span");
    $(statusSpan).attr("class", "chat-status");
    if (isOnline) {
      $(statusSpan).addClass("chat-online");
    } else {
      $(statusSpan).addClass("chat-offline");
    }
    var nameSpan = document.createElement("span");
    $(nameSpan).attr("class", "chat-username");
    $(nameSpan).append(username);
    var li = document.createElement("li");
    $(li).append(statusSpan);
    $(li).append(nameSpan);
    $(li).attr("title", username);
    $(li).attr("id", uid);
    $("#chat-left ul").append(li);
  }
}


function addUser(uid, username, isOnline) {
  console.log("addUser " + uid + username + isOnline);
  addUserToList(uid, username, isOnline);
  userList.push({id: uid, name: username});
  $.cookie("userList", JSON.stringify(userList), {path: '/'});
  getConversation(uid);
}

// 激活当前点击的对象
function activateItem(item) {
  console.log("activateItem");
  console.log(item);
  $("#chat-left li").removeClass("chat-active");
  $(item).addClass("chat-active");

  var id = $(item).attr("id");
  console.log(id);
  // 更改发送 form 的接收用户 id
  $("#message_receiver_id").val(id);

  $(".chat-message").hide();
  $(".chat-with-" + id).show();

  scrollDownDialogueList();
}

function activateUser(uid) {
  var str = "#chat-left li#" + uid;
  var tmp = $(str);
  activateItem(tmp);
}

function scrollDownDialogueList() {
  $("#chat-dialogue-list").scrollTop($("#chat-dialogue-list")[0].scrollHeight);
}

function onChatMessage(message) {
  console.log("onChatMessage");
  console.log(message);
  if (userExists(message.user_id)) {
    var header = document.createElement("div");
    $(header).attr("class", "chat-message-header");
    $(header).append(message.sender_name + " " + message.created_at);
    var content = document.createElement("div");
    $(content).append(message.content); // 后台已转义
    var messageDiv = document.createElement("div");
    $(messageDiv).attr("class", "chat-message chat-with-" + message.user_id);  
    $(messageDiv).append(header, content);
    $("#chat-dialogue-list").append(messageDiv);
    scrollDownDialogueList();
  } else {
    addUser(message.user_id, message.sender_name, true);
  }
}
