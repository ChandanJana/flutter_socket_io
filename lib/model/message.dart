/// Created by Chandan Jana on 21-12-2023.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com
///

class Message {
  final String text;
  final String senderId;
  final String receiverId;

  const Message({
    required this.text,
    required this.senderId,
    required this.receiverId,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        text: json['text'],
        senderId: json['senderId'],
        receiverId: json['receiverId'],
      );

  Map<String, dynamic> toJson() => {
        "receiverId": receiverId,
        "senderId": senderId,
        "message": text,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
