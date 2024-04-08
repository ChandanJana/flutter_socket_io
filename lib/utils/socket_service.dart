import 'dart:convert';
import 'dart:developer';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../model/Message.dart';
import '../model/friend.dart';
import '../model/login_model.dart';
import 'database_helper.dart';

/// Created by Chandan Jana on 18-12-2023.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com

class SocketService {
  /*IO.Socket socket = IO.io(
      // im using adb so i need to use my wifi ip
      'http://192.168.62.123:3000',
      IO.OptionBuilder()
          .setTransports(['websocket']) // for Flutter or Dart VM
          .disableAutoConnect() // disable auto-connection
          // .setExtraHeaders({'foo': 'bar'}) // optional
          .build());*/

  /*initConnection() async {
    socket.connect();
    socket.on('connection', (_) {
      log('connect ${_.toString()}');
    });
    log('Trying Connection');
    socket.onConnect((_) {
      log('connect');
    });

    socket.onerror((_) {
      log('Error Is ${_.toString()}');
    });

    socket.onDisconnect((data) {
      log('disconnect');
    });

    socket.on(
      'location',
      (data) {
        handleLocationListen(data);
      },
    );
    socket.on(
      'typing',
      (data) {
        handleTyping(data);
      },
    );

    socket.on(
      'message',
      (data) {
        handleMessage(data);
      },
    );

    // Listen for friend list changes from the server
    socket.on('friendList', (data) {
      final List<String> friendList = List<String>.from(data);
      context.read(friendListProvider.notifier).setFriendList(friendList);
    });

    currentUser = await DatabaseHelper().queryAll();
    friendList =
        users.where((user) => user.chatID != currentUser[0].id).toList();
  }*/

  // Send Location to Server
  /*void sendLocation(Map<String, dynamic> data) {
    socket.emit("location", data);
  }*/

  // Listen to Location updates of connected usersfrom server
  void handleLocationListen(Map<String, dynamic> data) async {
    print(data);
  }

  // Send update of user's typing status
  /*void sendTyping(bool typing) {
    socket.emit("typing", {
      "id": socket.id,
      "typing": typing,
    });
  }*/

  // Listen to update of typing status from connected users
  void handleTyping(Map<String, dynamic> data) {
    print(data);
  }

  // Listen to all message events from connected users
  void handleMessage(Map<String, dynamic> data) {
    print(data);
  }

  List<Friend> users = [
    Friend(name: 'IronMan', friendId: '111'),
    Friend(name: 'Captain America', friendId: '222'),
    Friend(name: 'Antman', friendId: '333'),
    Friend(name: 'Hulk', friendId: '444'),
    Friend(name: 'Thor', friendId: '555'),
  ];

  /*late List<LoginModel> currentUser;
  List<User> friendList = List.empty();
  List<Message> messages = List.empty();

  sendMessage(String message, String receiverChatID) {
    messages.add(Message(
        text: message,
        senderID: currentUser[0].id,
        receiverID: receiverChatID));
    socket.emit(
        'new_message',
        json.encode({
          'receiverId': receiverChatID,
          'senderId': currentUser[0].id,
          'message': message,
        }));
    //notifyListeners();
  }*/


 /* List<Message> getMessagesForChatID(String chatID) {
    return messages
        .where((msg) =>
            msg.senderID == currentUser[0].id || msg.receiverID == chatID)
        .toList();
  }*/
}
