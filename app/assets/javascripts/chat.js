var chatOpened = false; // 聊天窗口是否被打开过
var userList = []; // 获取到的用户列表 json 包括 id 和 name
var currentUid; // 当前正在和谁聊天
jQuery.fn.visible = function() {
    return this.css('visibility', 'visible');
};

jQuery.fn.invisible = function() {
    return this.css('visibility', 'hidden');
};

jQuery.fn.visibilityToggle = function() {
    return this.css('visibility', function(i, visibility) {
        return (visibility == 'visible') ? 'hidden' : 'visible';
    });
};
$(document).ready(function() {
  $("#chat-popup-button").click(function() {
    if (!chatOpened) {
      $("#chat-box").show();
      getUserList();
      chatOpened = true;
    } else {
      $("#chat-box").visibilityToggle();
    }
    if (currentUid) {
      $("#chat-sendbutton").prop("disabled", false);
    } else {
      $("#chat-sendbutton").prop("disabled", true);
    }
  });

  $("#chat-close").click(function() {
    $("#chat-box").invisible();
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

  setInterval(flicker, 1000);
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
    if (!currentUid) activateUser(userList[userList.length - 1].id);
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
  console.log("getconversation");
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
  item = $(item);
  var id = $(item).attr("id");
  if (item.hasClass("chat-unread"))
  {
    item.removeClass("chat-unread");
    var messageID = $(".chat-with-" + id + "[sender_id='" + id + "']").last().attr("message_id");
    console.log(messageID);
    readMessage(parseInt(messageID, 10));
  }
  item.addClass("chat-active");

  currentUid = parseInt(id, 10);
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

function readMessage(id) {
  $.ajax({
    url: "http://localhost:3000/chat/messages/"+id+"/read",
    type: "GET"
  });
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
    $(messageDiv).attr("sender_id", message.sender_id);  
    $(messageDiv).attr("message_id", message.id);  
    $(messageDiv).append(header, content);
    $("#chat-dialogue-list").append(messageDiv);
    if (currentUid === message.sender_id) {
      readMessage(message.id);
    } else if (message.read === false && message.sender_id === message.user_id) {
        $("#chat-left li#" + message.user_id).addClass("chat-unread");
    }
  } else {
    // 此时ajax获取历史消息
    addUser(message.user_id, message.sender_name, true);
  }
}

function onNewMessage(message) {
  onChatMessage(message);
  if (currentUid === message.user_id) {
    scrollDownDialogueList();
  } else {
    $(".chat-message").hide();
    $(".chat-with-" + currentUid).show();
    $("#chat-left li#" + message.user_id).addClass("chat-unread");
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

function flicker() {
  $(".chat-unread .chat-username").fadeOut().fadeIn();
}
