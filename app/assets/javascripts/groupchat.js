function onGroupChatMessage(message, roomID) {
  console.log("test");
  if (roomID == $("#message_room_id").val()) {
    $("#chatroom-dialogue-list").append(message.content);
  }
}
