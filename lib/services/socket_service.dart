import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { online, offline, connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.connecting;
  late IO.Socket _socket ; 
  ServerStatus get serverStatus => _serverStatus;
  IO.Socket get socket => _socket;
  SocketService() {
       _initConfig();
  }
  void _initConfig() {
    print(' entra al init config');
    _socket = IO.io('http://192.168.0.102:3001', {
      'transports': ['websocket'],
      'autoConnect': true
    });
    _socket.on('connect', (data) {
      print('Connected');
      _serverStatus = ServerStatus.online;
      notifyListeners();
    });
    _socket.on('disconnect', (data) {
      print('Disconnected');
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });
  }
}
