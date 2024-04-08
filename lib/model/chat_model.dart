import 'package:scoped_model/scoped_model.dart';

import './Message.dart';
import './friend.dart';
import '../utils/database_helper.dart';
import 'login_model.dart';

/// Created by Chandan Jana on 22-12-2023.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com
///

class ChatModel extends Model {
  List<Friend> users = [
    Friend(name: 'IronMan', friendId: '111'),
    Friend(name: 'Captain America', friendId: '222'),
    Friend(name: 'Antman', friendId: '333'),
    Friend(name: 'Hulk', friendId: '444'),
    Friend(name: 'Thor', friendId: '555'),
  ];

  late List<LoginModel> currentUser;
  List<Friend> friendList = List.empty();
  List<Message> messages = List.empty();

  //SocketIO socketIO;

  void init() async {
    //currentUser = users[0];
    currentUser = await DatabaseHelper().queryAll();
    friendList =
        users.where((friend) => friend.friendId != currentUser[0].id).toList();

    /*socketIO = SocketIOManager().createSocketIO(
        '<ENTER_YOUR_SERVER_URL_HERE>', '/',
        query: 'chatID=${currentUser.chatID}');
    socketIO.init();

    socketIO.subscribe('receive_message', (jsonData) {
      Map<String, dynamic> data = json.decode(jsonData);
      messages.add(Message(
          text: data['content'], senderID: data['senderID'], receiverID: data['receiverID']));
      notifyListeners();
    });

    socketIO.connect();*/
  }

  void sendMessage(String text, String receiverChatID) {
    /*messages.add(Message(text: text, senderID: currentUser[0].id, receiverID: receiverChatID));
    socketIO.sendMessage(
      'send_message',
      json.encode({
        'receiverID': receiverChatID,
        'senderID': currentUser[0].id,
        'content': text,
      }),
    );
    notifyListeners();*/
  }

/*List<Message> getMessagesForChatID(String chatID) {
    return messages
        .where((msg) => msg.senderID == currentUser[0].id || msg.receiverID == chatID)
        .toList();
  }*/
}
