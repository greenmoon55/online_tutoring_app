var chatOpened = false; // 聊天窗口是否被打开过
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
    if (!chatOpened) {
      getUserList();
      chatOpened = true;
    }
    $("#chat-box").show();
    var path = window.location.pathname;
    var uid = path.match(/\/users\/(\d*)/)[1];
    var username = $("#username").text();
    var isOnline = $("#img_online").length;
    addUser(uid, username, isOnline);
  });

  $("#chat-sendbutton").click(function() {
    $("#new_message").submit();
    $("#new_message").val("");
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

function getUserList() {
  $.ajax({
    url: "http://localhost:3000/chat/users",
    type: "GET",
    dataType: "json"
  }).done(function(data) {
    temp = data;
  });
}

function addUser(uid, username, isOnline) {
  console.log("addUser " + uid + username + isOnline);
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
  activateItem(str);
  $.ajax({
    url: "http://localhost:3000/chat/users/new?id="+uid,
    type: "GET",
  })
}

// 激活当前点击的对象
function activateItem(item) {
  $("#chat-left li").removeClass("chat-active");
  $(item).addClass("chat-active");

  id = $(item).attr("id");
  // 更改发送 form 的接收用户 id
  $("#message_receiver_id").val(id);

  $(".chat-message").hide();
  $(".chat-with-" + id).show();
}

function onChatMessage(message) {
  var header = document.createElement("div");
  $(header).attr("class", "chat-message-header");
  $(header).append(message.sender_name + " " + message.created_at);
  var content = document.createElement("div");
  $(content).append(message.content); // 后台已转义
  var messageDiv = document.createElement("div");
  $(messageDiv).attr("class", "chat-message chat-with-" + message.sender_id);  
  $(messageDiv).append(header, content);
  $("#chat-dialogue-list").append(messageDiv);
}
