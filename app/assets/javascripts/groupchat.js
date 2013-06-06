function onGroupChatMessage(message, roomID) {
  console.log("test");
  if (roomID == $("#message_room_id").val()) {
    $("#chatroom-dialogue-list").append(message.content);
  }
}
var context;

$(document).ready(function() {
  var drawing = document.getElementById("chatroom-canvas");
  if (drawing && drawing.getContext) {
    context = drawing.getContext("2d");
    context.beginPath();
    context.moveTo(100, 100);
    context.lineTo(35, 100);
    context.stroke();
  } else {
    // not supported
  }

  var drawingNow = false;
  var points = [];
  var canvas = $("#chatroom-canvas");
  canvas.mousedown(function(e) {
    console.log("mousedown");
    if (!drawingNow) {
      drawingNow = true;
      points = [];
      points.push([e.offsetX, e.offsetY]);
      context.beginPath();
    }
  });

  $("#chatroom-canvas").mousemove(function(e) {
    if (drawingNow) {
      points.push([e.offsetX, e.offsetY]);
      context.lineTo(e.offsetX, e.offsetY);
      context.stroke();
    }
  });

  $("#chatroom-canvas").mouseup(function() {
    finishDrawing();
  });

  function finishDrawing() {
    drawingNow = false;
    $.ajax({
      url: "http://localhost:3000/rooms/5/new_line",
      type: "GET",
      dataType: "json",
      data: {"points": points}
    }).success(function(data) {
    });
  }

  $("#chatroom-canvas").mouseleave(function() {
    if (drawingNow) {
      finishDrawing();
    }
  });

});

function draw(data) {
  console.log(data.points);
  var points = Array.prototype.slice.call(data.points);
  console.log(points);
  context.beginPath();
  context.moveTo(points[0][0], points[0][1]);
  console.log(points.length);
  for (var i = 1; i < points.length; i++) {
    console.log(i);
    context.lineTo(points[i][0], points[i][1]);
    context.stroke();
  }
}

