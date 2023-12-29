import 'package:flutter/material.dart';

class Util {
  static encryptOTP(String message, String key) {
    if (message.length != key.length) {
      throw Exception("Panjang pesan dan kunci harus sama.");
    }

    List<int> encrypted = [];
    for (int i = 0; i < message.length; i++) {
      int messageChar = message.codeUnitAt(i);
      int keyChar = key.codeUnitAt(i);

      int encryptedChar = messageChar ^ keyChar;
      encrypted.add(encryptedChar);
    }

    return String.fromCharCodes(encrypted);
  }

  static decryptOTP(String encryptedText, String key) {
    List<int> encrypted = encryptedText.runes.toList();
    if (encrypted.length != key.length) {
      throw Exception("Panjang teks terenkripsi dan kunci harus sama.");
    }

    String decryptedMessage = "";
    for (int i = 0; i < encrypted.length; i++) {
      int encryptedChar = encrypted[i];
      int keyChar = key.codeUnitAt(i);

      int decryptedChar = encryptedChar ^ keyChar;
      decryptedMessage += String.fromCharCode(decryptedChar);
    }

    return decryptedMessage;
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
