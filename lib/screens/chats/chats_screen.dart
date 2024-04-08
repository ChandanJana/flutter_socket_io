import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_chat/model/Message.dart';
import 'package:socket_chat/model/friend.dart';
import 'package:socket_chat/model/login_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../provider/chat_provider.dart';

/// Created by Chandan Jana on 18-12-2023.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com
///

class ChatsScreen extends ConsumerStatefulWidget {
  final Friend friend;

  const ChatsScreen({super.key, required this.friend});

  @override
  ConsumerState<ChatsScreen> createState() {
    return _ChatsScreenState();
  }
}

class _ChatsScreenState extends ConsumerState<ChatsScreen> {
  final TextEditingController textEditingController = TextEditingController();

  late IO.Socket socket;
  late LoginModel? loginModel;
  late Friend? selectedFriend;

  @override
  void initState() async {
    super.initState();
    //ScopedModel.of<SocketService>(context, rebuildOnChange: false).initConnection();
    loginModel = await ref.read(selectedUserProvider);
    selectedFriend = await ref.read(selectedFriendProvider);
    socket = await ref.read(socketIoClientProvider);
    // Fetch friend list when the screen is loaded
    socket.emit(
        'getFriendChatList',
        json.encode({
          'receiverId': selectedFriend?.friendId,
          'senderId': loginModel?.id,
          'message': textEditingController.text,
        }));

    // Listen for your own typing events and update the state accordingly
    textEditingController.addListener(() {
      final isTyping = textEditingController.text.isNotEmpty;
      socket.emit('typing', isTyping);
      //ref.read(typingProvider.notifier).state = isTyping;
    });
  }

  Widget buildSingleMessage(Message message) {
    return Container(
      alignment: message.senderId == selectedFriend?.friendId
          ? Alignment.centerLeft
          : Alignment.centerRight,
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.all(10.0),
      child: Text(message.text),
    );
  }

  Widget buildChatList(WidgetRef ref) {
    final isTyping = ref.watch(typingProvider);
    final messageList = ref.watch(messageListProvider);
    return messageList.isNotEmpty
        ? SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: ListView.builder(
              itemCount: messageList.length,
              itemBuilder: (BuildContext context, int index) {
                return buildSingleMessage(messageList[index]);
              },
            ),
          )
        : const Center(
            child: Text(
              'No Chats available',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          );
    /*return ScopedModelDescendant<SocketService>(
      builder: (context, child, model) {
        List<Message> messages =
            model.getMessagesForChatID(widget.friend.chatID);

        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          child: ListView.builder(
            itemCount: messages.length,
            itemBuilder: (BuildContext context, int index) {
              return buildSingleMessage(messages[index]);
            },
          ),
        );
      },
    );*/
  }

  /*Widget buildChatArea() {
    return ScopedModelDescendant<SocketService>(
      builder: (context, child, model) {
        return Container(
          child: Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  controller: textEditingController,
                ),
              ),
              SizedBox(width: 10.0),
              FloatingActionButton(
                onPressed: () {
                  model.sendMessage(
                      textEditingController.text, widget.friend.chatID);
                  textEditingController.text = '';
                },
                elevation: 0,
                child: Icon(Icons.send),
              ),
            ],
          ),
        );
      },
    );
  }*/

  @override
  Widget build(BuildContext context) {
    //final message = ref.watch(providerOfSocket);

    //final socket = ref.read(socketIoClientProvider);
    //final selectedFriend = ref.read(selectedFriendProvider);

    //final messageNotifier = ref.read(MessageNotifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.friend.name),
      ),
      body: ListView(
        children: <Widget>[
          buildChatList(ref),
          Container(
            child: Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                      controller: textEditingController,
                      decoration: InputDecoration(
                        hintText: 'Enter message',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              12.0), // Adjust the value as needed
                        ),
                        contentPadding: const EdgeInsets.all(10.0),
                      )),
                ),
                SizedBox(width: 10.0),
                FloatingActionButton(
                  onPressed: () {
                    var mes = Message.fromJson({'receiverId': selectedFriend!.friendId, 'senderId': loginModel!.id, 'text': textEditingController.text});
                    /*{
                      'receiverId': selectedFriend?.chatID,
                    'senderId': loginModel?.id,
                    'message': textEditingController.text,
                  }*/

                    socket.emit(
                        'new_message',
                        json.encode(mes));
                    textEditingController.text = '';
                    //ref.read(messageListProvider.notifier).addMessage(mes);
                  },
                  elevation: 0,
                  child: Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );

/*return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 50,
              width: 250,
              child: TextField(
                controller: _controller,
              ),
            ),
            ElevatedButton(
                onPressed: () => SocketService()
                    .sendMessage(_controller.text, widget.friend.chatID),
                child: const Text('Send Message')),
            const Divider(),
            Center(
              child: message.when(
                  data: (data) {
                    return Text(data.toString());
                  },
                  error: (_, __) {
                    log(_.toString());
                    return const Text('Error');
                  },
                  loading: () => const Text('Loading ')),
            )
          ],
        ),
      ),
    );*/
  }

  @override
  void dispose() {
    //SocketService().socket.disconnect();
    //SocketService().socket.dispose();
    textEditingController.dispose();
    super.dispose();
  }
}
