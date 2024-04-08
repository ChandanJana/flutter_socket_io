import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_chat/model/friend.dart';
import 'package:socket_chat/model/login_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

/// Created by Chandan Jana on 22-12-2023.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com
///

class ChatApiService{
  Friend? friend;
  LoginModel? loginModel;
  IO.Socket? socket;
  void sendNewMessage({required String message, required String sendId, required String receiverId}){
    if(socket != null) {
      socket?.emit(
          'new_message',
          json.encode({
            'receiverId': receiverId,
            'senderId': sendId,
            'message': message,
          }));
    }
  }
  IO.Socket getSocket(){
    if(socket == null) {
      /*socket = IO.io(Uri.parse('ws://172.16.5.149:5080/ws'), <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
      });*/
      socket = IO.io(
        // im using adb so i need to use my wifi ip
          //'http://192.168.62.123:3000',
        'ws://172.16.5.149:5080/ws',
          IO.OptionBuilder()
              .setTransports(['websocket']) // for Flutter or Dart VM
              .disableAutoConnect() // disable auto-connection
          // .setExtraHeaders({'foo': 'bar'}) // optional
              .build());
      socket?.connect();
      socket?.onConnect((_) {
        log("onConnect IS ${_.toString()}");
      });
      socket?.onDisconnect((_) {
        log("onDisconnect IS ${_.toString()}");
      });
      socket?.onError((_) {
        log("onError IS ${_.toString()}");
      });
      return socket!;
    }else{
      return socket!;
    }

  }
}

final apiServicesProvider = Provider<ChatApiService>((ref) => ChatApiService());