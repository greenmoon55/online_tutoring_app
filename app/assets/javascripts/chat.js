var chatOpened = false; // 聊天窗口是否被打开过
var userList = []; // 获取到的用户列表 json 包括 id 和 name
var currentUid; // 当前正在和谁聊天
$(document).ready(function() {
  $("#chat-popup-button").click(function() {
    if (!chatOpened) {
      $("#chat-box").show();
      getUserList();
      chatOpened = true;
      if (currentUid) activateUser(userList[userList.length - 1].id);
    } else {
      $("#chat-box").toggle();
    }
    if (currentUid) {
      $("#chat-sendbutton").prop("disabled", false);
    } else {
      $("#chat-sendbutton").prop("disabled", true);
    }
  });

  $("#chat-close").click(function() {
    $("#chat-box").hide();
    return false;
  });

  $("#chat-left").on("click", ".chat-user-close", function(event) {
    event.stopPropagation();
    var id = parseInt($(this).parent()[0].id, 10);
    removeUser(id);
    $.ajax({
      url: "http://localhost:3000/chat/users/" + id,
      type: "GET"
    });
  });

  $("#chat-left").on("click", "li", function() {
    activateItem(this);
  });

  $("#chat-with-button").click(function() {
    var path = window.location.pathname;
    var uid = path.match(/\/users\/(\d*)/)[1]; // 需要修改
    currentUid = parseInt(uid, 10);
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
    });
    return false;
  });

});

function userExists(uid) {
  var str = "#chat-left li#" + uid;
  // 判断是否已存在该用户
  return $(str).length;
}

function getUidsFromUserList() {
  var uids = [];
  for (i = 0; i < userList.length; i++) {
    uids.push(parseInt(userList[i].id, 10)); 
  }
  return uids;
}

// 从 cookie 获取用户列表
function getUserList() {
  if ($.cookie("userList")) {
    var i;
    userList = JSON.parse($.cookie("userList"));

    for (i = 0; i < userList.length; i++) {
      addUserToList(userList[i].id, userList[i].name, false);
    }

    var uids = getUidsFromUserList();
    getConversations(uids);
    getOnlineStatus(uids);
  }
}

function getConversations(uids) {
  console.log("getconversations");
  console.log(JSON.stringify({"users": uids}));
  if (!uids.length) return;
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
    var removeA = document.createElement("a");
    var removeI = $(document.createElement("i")).addClass("icon-remove");
    $(removeA).append(removeI);
    $(removeA).attr("class", "chat-user-close");
    var li = document.createElement("li");
    $(li).append(statusSpan);
    $(li).append(nameSpan);
    $(li).append(removeA);
    $(li).attr("title", username);
    $(li).attr("id", uid);
    $("#chat-left ul").append(li);
  }
}

// 不仅在界面显示，还要保存到 cookie 里，并获取在线状态
function addUser(id, username, isOnline) {
  id = parseInt(id, 10);
  if (userExists(id)) return;
  addUserToList(id, username, isOnline);
  userList.push({id: id, name: username});
  saveCookie();
  getConversation(id);
  getOnlineStatus(id);
  $.ajax({
    url: "http://localhost:3000/chat/users/new",
    type: "GET",
    data: {id: id}
  });
  if (userList.length === 1) {
    activateUser(id);
  }
}

function saveCookie() {
  $.cookie("userList", JSON.stringify(userList), {path: '/'});
}

function removeUser(uid) {
  $(".chat-with-"+uid).remove();
  var currentLi = $("#"+uid);
  if (!currentLi.length) return;
  if (currentLi.hasClass("chat-active")) {
    currentLi.remove();
    if ($("#chat-left li").length) {
      activateItem($("#chat-left li").last());
    } else {
      // 没有用户了
      currentUid = null;
      $("#chat-sendbutton").prop("disabled", true);
    }
  } else {
    currentLi.remove();
  }
  for (var i = 0; i < userList.length; i++) {
    if (userList[i].id == uid) {
      userList.splice(i, 1);
      break;
    }
  }
  console.log(userList);
  saveCookie();
}

// 激活当前点击的对象
function activateItem(item) {
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

function setOnline(uid) {
  $("#chat-left li#"+ uid + " .chat-status").removeClass("chat-offline")
    .addClass("chat-online");
}

function updateOnlineStatus(onlineUids) {
  $("#chat-left .chat-status").removeClass("chat-online chat-offline")
    .addClass("chat-offline");
  for (var i = 0; i < onlineUids.length; i++) {
    setOnline(onlineUids[i]);
  }
}

function getOnlineStatus(uids) {
  $.ajax({ 
    url: "http://localhost:3000/refresh", 
    type: "GET",
    dataType: "json",
    data: {"users": getUidsFromUserList()},
    success: function(data){
      updateOnlineStatus(data.uids);  
    }
  });
}
