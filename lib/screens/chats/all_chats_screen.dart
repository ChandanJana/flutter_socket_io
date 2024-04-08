import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_chat/model/friend.dart';
import 'package:socket_chat/screens/chats/chats_screen.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../provider/chat_provider.dart';

/// Created by Chandan Jana on 22-12-2023.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com
///

class AllChatsScreen extends ConsumerStatefulWidget {
  const AllChatsScreen({super.key});

  @override
  ConsumerState<AllChatsScreen> createState() => _AllChatsPageState();
}

class _AllChatsPageState extends ConsumerState<AllChatsScreen> {
  late IO.Socket socket;

  @override
  void initState() {
    super.initState();
    //ScopedModel.of<SocketService>(context, rebuildOnChange: false).initConnection();
    socket = ref.read(socketIoClientProvider);
    // Fetch friend list when the screen is loaded
    socket.emit('getFriendList', 'userId');
  }

  void friendClicked(Friend friend) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return ChatsScreen(
            friend: friend,
          );
        },
      ),
    );
  }

  /*Widget buildAllChatList() {
    return ScopedModelDescendant<SocketService>(
      builder: (context, child, model) {
        return ListView.builder(
          itemCount: model.friendList.length,
          itemBuilder: (BuildContext context, int index) {
            User friend = model.friendList[index] as User;
            return ListTile(
              title: Text(friend.name),
              onTap: () => friendClicked(friend),
            );
          },
        );
      },
    );
  }*/

  @override
  Widget build(BuildContext context) {
    //final socket = ref.read(socketIoClientProvider);

    var friendList = ref.watch(friendListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Chats'),
      ),
      //body: buildAllChatList(),
      body: friendList.isNotEmpty
          ? ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(friendList[index].name),
                  onTap: () {
                    ref.read(selectedFriendProvider.notifier).state =
                        friendList[index];
                    friendClicked(friendList[index]);
                  },
                );
              },
              itemCount: friendList.length,
            )
          : const Center(
            child: Text(
              'No Friends available',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
              ),
            ),
          ),
    );
  }
}
