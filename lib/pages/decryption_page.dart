import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:steglock2/supports/util.dart';

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
              decoration:
                  InputDecoration(labelText: 'Masukkan Teks Terenkripsi'),
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
                        content: Text(
                            'Panjang teks terenkripsi dan kunci harus sama.'),
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
                // result = Util.decrypt(encryptedText, key);

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
                              await Clipboard.setData(
                                  ClipboardData(text: result));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Teks berhasil disalin ke Clipboard')),
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
