const express = require("express");
const app = express();
const http = require("http").createServer(app);
const io = require("socket.io")(http);

const port = process.env.PORT || 5000;

const users = {};

io.on("connection", (socket) => {
  console.log("A user connected");

  // Listen for new user join event
  socket.on("join", (userId) => {
    users[userId] = socket.id;

    console.log(users);
  });

  // Listen for incoming messages from Flutter client
  socket.on("message", ({ senderId, receiverId, message }) => {
    const receiverSocketId = users[receiverId];

    if (receiverSocketId) {
      io.to(receiverSocketId).emit("message", { senderId, message });
    }
  });

  // Handle disconnection
  socket.on("disconnect", (data) => {
    console.log("A user disconnected: ", data);
  });
});

http.listen(port, () => {
  console.log(`Server listening on port ${port}`);
});
