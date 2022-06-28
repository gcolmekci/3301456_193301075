import 'package:flutter/material.dart';
import 'package:school_project/const_files/colors.dart';

class MyLoader {
  static Future showLoader(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(
            backgroundColor: whiteColor,
            color: succesColor,
          )
        ],
      ),
    ).whenComplete(() => "something");
  }
}
