import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget { 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StegLock',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

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
                  MaterialPageRoute(builder: (context) => EncryptionPage()),
                );
              },
              child: Text('Encode'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EncryptionPage()),
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

class EncryptionPage extends StatefulWidget {
  @override
  _EncryptionPageState createState() => _EncryptionPageState();
}

class _EncryptionPageState extends State<EncryptionPage> {
  TextEditingController messageController = TextEditingController();
  TextEditingController keyController = TextEditingController();
  String result = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enkripsi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             ElevatedButton(
              onPressed: () async {
                // Menggunakan file_picker untuk memilih file
                FilePickerResult? result = await FilePicker.platform.pickFiles();

                if (result != null) {
                  // Baca isi file
                  String fileContent = String.fromCharCodes(result.files.single.bytes!);

                  // Update teks di TextField
                  messageController.text = fileContent;
                }
              },
              child: Text('Pilih Pesan dari File'),
            ),
            TextField(
              controller: messageController,
              decoration: InputDecoration(labelText: 'Masukkan Pesan'),
            ),
            TextField(
              controller: keyController,
              decoration: InputDecoration(labelText: 'Masukkan Kunci'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String message = messageController.text;
                String key = keyController.text;

          if (message.length != key.length) {
                // Menampilkan AlertDialog jika panjang pesan dan kunci tidak sama
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Warning!'),
                      content: Text('Panjang pesan dan kunci harus sama.'),
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
                return; // Hentikan eksekusi lebih lanjut jika panjang tidak sama
              }

                // Perform encryption
                result = encryptOTP(message, key);

                // Display result
                 showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hasil Enkripsi'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SelectableText(result),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  // Menyalin hasil ke Clipboard
                  await Clipboard.setData(ClipboardData(text: result));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Teks berhasil disalin ke Clipboard')),
                  );
                },
                child: Text('Salin'),
              ),
            ],
          ),
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
  },
              child: Text('Enkripsi'),
            ),
          ],
        ),
      ),
    );
  }
}

class DecryptionPage extends StatefulWidget {
  @override
  _DecryptionPageState createState() => _DecryptionPageState();
}

class _DecryptionPageState extends State<DecryptionPage> {
  TextEditingController encryptedTextController = TextEditingController();
  TextEditingController keyController = TextEditingController();
  String result = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deskripsi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: encryptedTextController,
              decoration: InputDecoration(labelText: 'Masukkan Teks Terenkripsi'),
            ),
            TextField(
              controller: keyController,
              decoration: InputDecoration(labelText: 'Masukkan Kunci'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String encryptedText = encryptedTextController.text;
                String key = keyController.text;

              if (encryptedText.length != key.length) {
      // Menampilkan AlertDialog jika panjang teks terenkripsi dan kunci tidak sama
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Kesalahan'),
            content: Text('Panjang teks terenkripsi dan kunci harus sama.'),
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
      return; // Hentikan eksekusi lebih lanjut jika panjang tidak sama
    }

            
                // Perform decryption
                result = decryptOTP(encryptedText, key);

                // Display result
                showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hasil Deskripsi'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SelectableText(result),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  // Menyalin hasil ke Clipboard
                  await Clipboard.setData(ClipboardData(text: result));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Teks berhasil disalin ke Clipboard')),
                  );
                },
                child: Text('Salin'),
              ),
            ],
          ),
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
  },
              child: Text('Deskripsi'),
            ),
          ],
        ),
      ),
    );
  }
}

String encryptOTP(String message, String key) {
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

String decryptOTP(String encryptedText, String key) {
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

