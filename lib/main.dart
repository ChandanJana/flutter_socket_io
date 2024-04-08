import 'dart:io';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:socket_chat/provider/chat_provider.dart';
import 'package:socket_chat/screens/chats/all_chats_screen.dart';
import 'package:socket_chat/screens/login/login_screen.dart';
import 'package:socket_chat/screens/splash/splash_screen.dart';
import 'package:socket_chat/utils/database_helper.dart';
import 'package:socket_chat/utils/socket_service.dart';

import 'model/login_model.dart';
import 'resouces/app_resource.dart';

void main() {
  HttpOverrides.global = AssetHttpOverrides();
  // call initial connection in the main
  // assuming you want the connection to be continuous
  //SocketService().initConnection();
  runApp(const ProviderScope(
    child: ChatApp(),
  ));
}

class AssetHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class ChatApp extends ConsumerStatefulWidget {
  const ChatApp({super.key});

  @override
  ConsumerState<ChatApp> createState() {
    return _ChatAppState();
  }
}

late List<LoginModel> data;

Future<bool> checkLoginState(WidgetRef ref) async {
  //SharedPreferences prefs = await SharedPreferences.getInstance();
  //bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  data = await DatabaseHelper().queryAll();

  print('User LoginModel data: $data');
  if (data.isNotEmpty) {
    ref.read(selectedUserProvider.notifier).state = data[0];
    //Navigator.pushReplacementNamed(context, '/home');
    return true;
  }
  return false;
}

class _ChatAppState extends ConsumerState<ChatApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppTexts.appName,
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen.withScreenFunction(
        //duration: 3000,
        splash: const SplashScreen(),
        screenFunction: () async {
          // Your code here
          var dataExist = await checkLoginState(ref);
          return dataExist ? const AllChatsScreen() : const LoginScreen();
        },
        //nextScreen: content,
        splashTransition: SplashTransition.scaleTransition,
        pageTransitionType: PageTransitionType.rightToLeft,
        backgroundColor: Colors.blue,
      ),
    );
  }
}
