function onGroupChatMessage(message, roomID) {
  console.log("test");
  if (roomID == $("#message_room_id").val()) {
    $("#chatroom-dialogue-list").append(message.content);
  }
}

$(document).ready(function() {
  var drawing = document.getElementById("chatroom-canvas");
  if (drawing && drawing.getContext) {
    var context = drawing.getContext("2d");
    context.beginPath();
    context.moveTo(100, 100);
    context.lineTo(35, 100);
    context.stroke();
  } else {
    // not supported
  }

  var drawingNow = false;
  $("#chatroom-canvas").mousedown(function() {
    console.log("mousedown");
    if (!drawingNow) {
      drawingNow = true;
      context.beginPath();
    }
  });

  $("#chatroom-canvas").mousemove(function(e) {
    if (drawingNow) {
      context.lineTo(e.offsetX, e.offsetY);
      context.stroke();
    }
  });

  $("#chatroom-canvas").mouseup(function() {
    drawingNow = false;
  });
});

