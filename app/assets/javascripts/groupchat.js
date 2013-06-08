// http://stackoverflow.com/questions/2142535/how-to-clear-the-canvas-for-redrawing
CanvasRenderingContext2D.prototype.clear = 
  CanvasRenderingContext2D.prototype.clear || function (preserveTransform) {
    if (preserveTransform) {
      this.save();
      this.setTransform(1, 0, 0, 1, 0, 0);
    }

    this.clearRect(0, 0, this.canvas.width, this.canvas.height);

    if (preserveTransform) {
      this.restore();
    }           
};

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
      type: "POST",
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

function clearAndUpdate() {
  context.clear();  
  $.ajax({
    url: "http://localhost:3000/rooms/5/clear",
    type: "GET",
  }).success(function(data) {
  });
}

function onGroupChatMessage(message, roomID) {
  console.log("test");
  if (roomID == $("#message_room_id").val()) {
    $("#chatroom-dialogue-list").append(message.content);
  }
}
