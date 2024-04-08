/// Created by Chandan Jana on 10-09-2023.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com

class LoginResponseModel {
  String? token;
  String? message;
  String? messageDetails;
  bool? isSuccess;

  LoginResponseModel(
      {this.token, this.message, this.messageDetails, this.isSuccess});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    message = json['message'];
    messageDetails = json['messageDetails'];
    isSuccess = json['isSuccess'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['message'] = message;
    data['messageDetails'] = messageDetails;
    data['isSuccess'] = isSuccess;
    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
