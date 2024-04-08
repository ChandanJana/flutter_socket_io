/// Created by Chandan Jana on 10-09-2023.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com

class AppApi {
  // Api Name
  //static const String _baseApi = 'http://192.168.10.202';
  static const String _baseApi = 'https://iotace.mindteck.com';
  static const String loginApi = '$_baseApi/devicehub/Authentication/Login';
  static const String logoutApi = '$_baseApi/devicehub/Authentication/Logout';
}
