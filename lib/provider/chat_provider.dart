import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_chat/model/Message.dart';
import 'package:socket_chat/model/friend.dart';
import 'package:socket_chat/model/login_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'chat_api_service.dart';

/// Created by Chandan Jana on 18-12-2023.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com

final providerOfSocket = StreamProvider.autoDispose((ref) async* {
  StreamController stream = StreamController();

  ref.read(socketIoClientProvider).on('broadcast', (data) {
    stream.add(data);

    log(data.toString());
  });

  // SocketService().socket.on('message', (data) {
  //   stream.add(data);
  //   log(data);
  // });

  ref.read(socketIoClientProvider).onConnect((_) {
    log("Error IS ${_.toString()}");
  });
  ref.read(socketIoClientProvider).onDisconnect((_) {
    log("Error IS ${_.toString()}");
  });
  ref.read(socketIoClientProvider).onError((_) {
    log("Error IS ${_.toString()}");
  });

  /** if you using .autDisopose */
  // ref.onDispose(() {
  //   // close socketio
  //   _stream.close();
  //   SocketService().socket.dispose();
  // });

  await for (final value in stream.stream) {
    log('stream value => ${value.toString()}');
    yield value;
  }
});

/*sendMessage(String message, String receiverChatID) {
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

final socketIoClientProvider = Provider<IO.Socket>((ref) {
  /*final socket = IO.io(
    // im using adb so i need to use my wifi ip
      'http://192.168.62.123:3000',
      IO.OptionBuilder()
          .setTransports(['websocket']) // for Flutter or Dart VM
          .disableAutoConnect() // disable auto-connection
      // .setExtraHeaders({'foo': 'bar'}) // optional
          .build());*/
  var socket = ref.read(apiServicesProvider).getSocket();

  // Listen for friend list changes from the server
  socket.on('friendList', (data) {
    final List<Friend> friendList1 = List<Friend>.from(data);
    ref.read(friendListProvider.notifier).setFriendList(friendList1);
  });

  // Listen for friend list changes from the server
  socket.on('getFriendChatList', (data) {
    final List<Message> messageList = List<Message>.from(data);
    ref.read(messageListProvider.notifier).state = messageList;
  });

  // Listen for messages from the server
  socket.on('new_message', (data) {
    print('Message received: $data');
    // Handle the received message as needed
    var mes = Message.fromJson({'receiverId': data['receiverId'], 'senderId': data['senderId'], 'text': data['text']});
    ref.read(messageListProvider.notifier).addMessage(mes);
  });

  socket.on('typing', (data) {
    // Handle the typing event
    ref.read(typingProvider.notifier).state = true;
  });

  return socket;
});

final friendListProvider = StateNotifierProvider<FriendListNotifier, List<Friend>>((ref) {
  return FriendListNotifier();
});

final messageListProvider = StateNotifierProvider<MessageNotifier, List<Message>>((ref) {
  return MessageNotifier();
});


final selectedFriendProvider = StateProvider<Friend?>((ref) {
  return ref.read(apiServicesProvider).friend;
});

final selectedUserProvider = StateProvider<LoginModel?>((ref) {
  return ref.read(apiServicesProvider).loginModel;
});

// Define a provider to track the typing state
final typingProvider = StateProvider<bool>((ref) => false);

class FriendListNotifier extends StateNotifier<List<Friend>> {
  FriendListNotifier() : super([]);

  void setFriendList(List<Friend> friends) {
    state = friends;
  }
}

class MessageNotifier extends StateNotifier<List<Message>> {
  MessageNotifier() : super([]);

  void addMessage(Message message) {
    state = [...state, message];
  }
}
