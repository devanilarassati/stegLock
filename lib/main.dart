import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';



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
              onPressed : _pickMessageFromFile,
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

class SteganographyPage extends StatefulWidget {
  @override
  _SteganographyPageState createState() => _SteganographyPageState();
}

class _SteganographyPageState extends State<SteganographyPage> {
  File? _imageFile;
  String _message = '';
  TextEditingController _messageController = TextEditingController();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _messageController.text = ''; // Reset the message when a new image is picked
      });
    }
  }

  Future<void> _saveImage() async {
  if (_imageFile == null) {
    return;
  }

  // Menggunakan package path_provider untuk mendapatkan direktori penyimpanan eksternal
  final directory = await getExternalStorageDirectory();
  final imagePath = '${directory!.path}/hidden_image.png';

  // Menyimpan gambar tersembunyi
  await _imageFile!.copy(imagePath);

  // Menampilkan pesan sukses
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


  Future<void> _hideMessage() async {
    if (_imageFile == null) {
      return;
    }

    final bytes = await _imageFile!.readAsBytes();
    final image = img.decodeImage(Uint8List.fromList(bytes));

    if (image != null) {
      String message = _messageController.text;

      if (message.isNotEmpty) {
        // Convert the message to binary
        List<int> binaryMessage = message.codeUnits.expand((int unit) => unit.toRadixString(2).padLeft(8, '0').codeUnits).toList();

        // Hide the binary message in the image
        int bitIndex = 0;
        for (int y = 0; y < image.height; y++) {
          for (int x = 0; x < image.width; x++) {
            if (bitIndex < binaryMessage.length) {
              int pixel = image.getPixel(x, y);
              int newPixel = (pixel & 0xFE) | (binaryMessage[bitIndex] - 48); // Change the least significant bit
              image.setPixel(x, y, newPixel);
              bitIndex++;
            } else {
              break;
            }
          }
          if (bitIndex >= binaryMessage.length) {
            break;
          }
        }

        // Save the modified image
        final hiddenImage = img.encodePng(image!);
        setState(() {
          _imageFile = File.fromRawPath(Uint8List.fromList(hiddenImage!));
        });
      }
    }
  }

  Future<void> _revealMessage() async {
    if (_imageFile == null) {
      return;
    }

    final bytes = await _imageFile!.readAsBytes();
    final image = img.decodeImage(Uint8List.fromList(bytes));

    if (image != null) {
      List<int> binaryMessage = [];

      for (int y = 0; y < image.height; y++) {
        for (int x = 0; x < image.width; x++) {
          int pixel = image.getPixel(x, y);
          binaryMessage.add(pixel & 0x01 + 48); // Extract the least significant bit and convert to ASCII
        }
      }

      // Convert binary to text
      String message = String.fromCharCodes(List.generate((binaryMessage.length / 8).floor(), (index) => int.parse(String.fromCharCodes(binaryMessage.sublist(index * 8, (index + 1) * 8)), radix: 2)));
      
      setState(() {
        _message = message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Steganography'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: Text('Choose Image'),
            ),
            SizedBox(height: 16),
            _imageFile != null
                ? Image.file(
                    _imageFile!,
                    height: 200,
                  )
                : Container(),
            SizedBox(height: 16),
            TextField(
              controller: _messageController,
              decoration: InputDecoration(labelText: 'Enter Message'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _hideMessage,
              child: Text('Hide Message'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveImage, // Tambahkan fungsi untuk menyimpan gambar
              child: Text('Save Image'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _revealMessage,
              child: Text('Reveal Message'),
            ),
            SizedBox(height: 16),
            Text('Revealed Message: $_message'),
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

