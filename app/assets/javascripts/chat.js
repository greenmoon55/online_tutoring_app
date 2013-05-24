$(document).ready(function() {
  $("#chat-popup-button").click(function() {
    $("#chat-box").toggle();
  });
  $("#chat-close").click(function() {
    $("#chat-box").hide();
    return false;
  })
  $("#chat-left").on("click", "li", function() {
    activateItem(this);
  })
  $("#chat-with-button").click(function() {
    $("#chat-box").show();
    var path = window.location.pathname;
    var uid = path.match(/\/users\/(\d*)/)[1];
    var username = $("#username").text();
    var isOnline = $("#img_online").length;
    addUser(uid, username, isOnline);
  });
});

function addUser(uid, username, isOnline) {
  console.log("addUser " + uid + username + isOnline);
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
  $("#chat-left ul").append(li);
}

// 激活当前点击的对象
function activateItem(item) {
  $("#chat-left li").removeClass("chat-active");
  $(item).addClass("chat-active");
}
