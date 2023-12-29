import 'package:flutter/material.dart';
import 'package:steglock2/pages/decryption_page.dart';
import 'package:steglock2/pages/encryption_page.dart';
import 'package:steglock2/pages/steganography_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('StegLock'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EncryptionPage()),
                );
              },
              child: Text('Enkripsi'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DecryptionPage()),
                );
              },
              child: Text('Deskripsi'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SteganographyPage()),
                );
              },
              child: Text('Encode'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SteganographyPage()),
                );
              },
              child: Text('Decode'),
            ),
          ],
        ),
      ),
    );
  }
}