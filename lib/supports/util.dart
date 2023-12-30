import 'dart:math';

import 'package:flutter/material.dart';

class Util {
  // static e.Encrypted encrypt(String message, String key) {
  //   final utfKey = e.Key.fromUtf8(key);
  //   final encrypter = e.Encrypter(e.AES(utfKey, mode: e.AESMode.cbc));
  //   final initVector = e.IV.fromUtf8(key.substring(0, 16));
  //   e.Encrypted encryptedData = encrypter.encrypt(message, iv: initVector);
  //   return encryptedData;
  // }

  // static String decrypt(e.Encrypted encryptedText, String key) {
  //   final utfKey = e.Key.fromUtf8(key);
  //   final encrypter = e.Encrypter(e.AES(utfKey, mode: e.AESMode.cbc));
  //   final initVector = e.IV.fromUtf8(key.substring(0, 16));
  //   return encrypter.decrypt(encryptedText, iv: initVector);
  // }

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

  static showInfoDialog(BuildContext context, Function onYes) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Hidden image saved successfully!'),
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
