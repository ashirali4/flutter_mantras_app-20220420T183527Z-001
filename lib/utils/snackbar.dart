import 'package:flutter/material.dart';
import 'package:flutter_mantras_app/utils/colors.dart';


class SnackBarMessage {
  static void show({required BuildContext context, required String message, int duration=2}) {

    // Remove current visible snack-bar
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    // Show snack-bar
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontFamily: "Raleway",
            fontStyle: FontStyle.normal,
            fontSize: 15.0
        ),
        textScaleFactor: MediaQuery.of(context).size.width/405,
      ),
      duration: Duration(seconds: duration),
      backgroundColor: kPurple,
      elevation: (8*MediaQuery.of(context).size.width)/405,
      behavior: SnackBarBehavior.floating,
    ));
  }
}