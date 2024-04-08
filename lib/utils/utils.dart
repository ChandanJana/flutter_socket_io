import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

import '../resouces/app_resource.dart';

/// Created by Chandan Jana on 10-09-2023.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com

// Singleton class
class Utils {
  // Private constructor
  Utils._();

  // Singleton instance
  // The one and only instance of this singleton
  // In Dart, all global variables are lazy-loaded naturally. This implies
  // that they are possibly initialized when they are first utilized.
  static final Utils _instance = Utils._();

  // Factory constructor to get the instance
  factory Utils() {
    return _instance;
  }

  final Logger logger = Logger(AppTexts.appName);

  Future<String> get _localPath async {
    var directory = await getExternalStorageDirectory();
    directory ??= await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/asset_tracker.txt');
  }

  void setupLogging() async {
    File file = await _localFile;
    Logger.root.level = Level.ALL; // Set the logging level
    Logger.root.onRecord.listen((record) {
      // Print log messages to the console
      print('${record.level.name}: ${record.time}: ${record.message}');

      // Write log messages to a file
      file.writeAsStringSync(
        '${record.level.name}: ${record.time}: ${record.message}\n',
        mode: FileMode.append,
      );
    });
  }

  void fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          LoadingAnimationWidget.staggeredDotsWave(
            color: Colors.blueAccent,
            size: 70,
          ),
          Container(
              margin: const EdgeInsets.only(left: 7),
              child: const Text("Please wait...")),
        ],
      ),
    );
    showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Container(
          height: 300,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
          ),
          child: const SizedBox.expand(child: FlutterLogo()),
        );
      },
      transitionBuilder: (ctx, anim, a2, child) {
        var curve = Curves.easeInOut.transform(anim.value);
        return Transform.scale(
          scale: curve,
          filterQuality: FilterQuality.medium,
          child: alert,
        );
      },
      transitionDuration: const Duration(milliseconds: 250),
      barrierDismissible: false,
      barrierLabel: "Barrier",
      barrierColor: Colors.black.withOpacity(0.5),
    );
    /*showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );*/
  }

  Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }
}
