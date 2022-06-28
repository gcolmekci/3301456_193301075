import 'package:flutter/material.dart';

class CustomSnackBar {
  static customSnackBar(BuildContext context, String content,
      {SnackBarAction? snackBarAction, Color backgroundColor = Colors.green}) {
    final SnackBar snackBar = SnackBar(
        action: snackBarAction,
        duration: const Duration(seconds: 3),
        backgroundColor: backgroundColor,
        content: Text(
          content,
          style: Theme.of(context).textTheme.bodyText2,
        ),
        behavior: SnackBarBehavior.floating);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
