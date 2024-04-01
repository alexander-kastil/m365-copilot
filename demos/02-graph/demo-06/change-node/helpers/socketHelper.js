import express from 'express';
import http from 'http';
import io from 'socket.io';
import { subscriptionConfiguration, msalConfiguration } from '../constants';

const socketServer = http.createServer(express);
export const ioServer = io(socketServer, {
  cors: {
    origin: [
      msalConfiguration.redirectUri.substring(0, msalConfiguration.redirectUri.lastIndexOf('/')),
      subscriptionConfiguration.notificationUrl.substring(0, subscriptionConfiguration.notificationUrl.lastIndexOf('/'))],
    methods: ['GET', 'POST']
  }
});

socketServer.listen(3001);

// Socket event
ioServer.on('connection', socket => {
  socket.on('create_room', subscriptionId => {
    socket.join(subscriptionId);
  });
});
