$(document).ready(function() {
  $("#chat-popup-button").click(function() {
    $("#chat-box").toggle();
  });
  $("#chat-close").click(function() {
    $("#chat-box").hide();
    return false;
  });
  $("#chat-left").on("click", "li", function() {
    activateItem(this);
  });
  $("#chat-with-button").click(function() {
    $("#chat-box").show();
    var path = window.location.pathname;
    var uid = path.match(/\/users\/(\d*)/)[1];
    var username = $("#username").text();
    var isOnline = $("#img_online").length;
    addUser(uid, username, isOnline);
  });
  $("#chat-sendbutton").click(function() {
    alert("sendbutton");
    $("#new_message").submit();
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
}

// 激活当前点击的对象
function activateItem(item) {
  $("#chat-left li").removeClass("chat-active");
  $(item).addClass("chat-active");
  $("#message_receiver_id").val($(item).attr("id"));
}
