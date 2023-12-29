import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:steglock2/supports/util.dart';

class EncryptionPage extends StatefulWidget {
  @override
  _EncryptionPageState createState() => _EncryptionPageState();
}

class _EncryptionPageState extends State<EncryptionPage> {
  TextEditingController messageController = TextEditingController();
  TextEditingController keyController = TextEditingController();
  String result = '';

  Future<void> _pickMessageFromFile() async {
    FilePickerResult? fileResult = await FilePicker.platform.pickFiles();

    if (fileResult != null) {
      String fileContent = String.fromCharCodes(fileResult.files.single.bytes!);
      print('Panjang pesan: ${fileContent.length}');

      setState(() {
        messageController.text = fileContent;
      });
    }
  }

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
              onPressed: _pickMessageFromFile,
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
                result = Util.encryptOTP(message, key);

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
              child: Text('Enkripsi'),
            ),
          ],
        ),
      ),
    );
  }
}
