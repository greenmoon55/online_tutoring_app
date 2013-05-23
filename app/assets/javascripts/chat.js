$(document).ready(function() {
  $("#chat-popup-button").click(function() {
    $("#chat-box").toggle();
  });
  $("#chat-close").click(function() {
    $("#chat-box").hide();
    return false;
  })
});
