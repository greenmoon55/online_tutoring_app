// http://stackoverflow.com/questions/2142535/how-to-clear-the-canvas-for-redrawing
CanvasRenderingContext2D.prototype.clear = 
  CanvasRenderingContext2D.prototype.clear || function (preserveTransform) {
    if (preserveTransform) {
      this.save();
      this.setTransform(1, 0, 0, 1, 0, 0);
    }

    this.clearRect(0, 0, this.canvas.width, this.canvas.height);

    if (preserveTransform) {
      this.restore(); }           
  };

var context;
var color = "000000";
var lineWidth = 1;
var roomID;

$(document).ready(function() {
  var path = window.location.pathname;
  var re = /\d+/g;
  var matches = path.match(re);
  if (matches && matches.length >= 2) {
    var roomID = parseInt(matches[matches.length - 1], 10);
  }
  var drawing = document.getElementById("chatroom-canvas");
  if (drawing && drawing.getContext) {
    context = drawing.getContext("2d");
  } else {
    // not supported
  }

  var drawingNow = false;
  var points = [];
  var canvas = $("#chatroom-canvas");
  canvas.mousedown(function(e) {
    if (!drawingNow) {
      drawingNow = true;
      points = [];
      points.push([e.offsetX, e.offsetY]);
      context.fillStyle = color;
      context.strokeStyle = color;
      context.lineWidth = lineWidth;
      context.beginPath();
    }
    return false; // 禁止用户拖动 
  });

  canvas.mousemove(function(e) {
    if (drawingNow) {
      points.push([e.offsetX, e.offsetY]);
      context.lineTo(e.offsetX, e.offsetY);
      context.stroke();
    }
  });

  canvas.mouseup(function() {
    finishDrawing();
  });

  canvas.mouseleave(function() {
    if (drawingNow) {
      finishDrawing();
    }
  });
  function finishDrawing() {
    drawingNow = false;
    $.ajax({
      url: "http://localhost:3000/rooms/" + roomID + "/new_line",
      type: "POST",
      dataType: "json",
      data: {
        "points": points,
        "color": color,
        "lineWidth": lineWidth
      }
    }).success(function(data) {
    });
  }
});


function draw(data) {
  context.fillStyle = data.color;
  context.strokeStyle = data.color; 
  context.lineWidth = data.lineWidth;
  var points = Array.prototype.slice.call(data.points);
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
    url: "http://localhost:3000/rooms/" + roomID + "/clear",
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
