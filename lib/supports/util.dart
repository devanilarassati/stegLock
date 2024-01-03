import 'dart:math';

import 'package:flutter/material.dart';

class Util {

  static String generateKey(int length) {
    const String charset =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()_+';
    Random random = Random();
    String key = '';

    for (int i = 0; i < length; i++) {
      int randomIndex = random.nextInt(charset.length);
      key += charset[randomIndex];
    }
    return key;
  }

  static showInfoDialog(BuildContext context, String message, Function onYes) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text(message),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

    static showInfoDialogWarning(BuildContext context, String message, Function onYes) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Warning!'),
          content: Text(message),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
