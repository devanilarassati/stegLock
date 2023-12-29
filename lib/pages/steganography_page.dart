import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:steglock2/supports/util.dart';
import 'package:image/image.dart' as img;

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
        _messageController.text =
            ''; // Reset the message when a new image is picked
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
    _imageFile!.copy(imagePath).then((value) {
      Util.showInfoDialog(context, () {
        Navigator.of(context).pop();
      });
    });
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
        List<int> binaryMessage = message.codeUnits
            .expand(
                (int unit) => unit.toRadixString(2).padLeft(8, '0').codeUnits)
            .toList();

        // Hide the binary message in the image
        int bitIndex = 0;
        for (int y = 0; y < image.height; y++) {
          for (int x = 0; x < image.width; x++) {
            if (bitIndex < binaryMessage.length) {
              int pixel = image.getPixel(x, y);
              int newPixel = (pixel & 0xFE) |
                  (binaryMessage[bitIndex] -
                      48); // Change the least significant bit
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
          binaryMessage.add(pixel &
              0x01 +
                  48); // Extract the least significant bit and convert to ASCII
        }
      }

      // Convert binary to text
      String message = String.fromCharCodes(List.generate(
          (binaryMessage.length / 8).floor(),
          (index) => int.parse(
              String.fromCharCodes(
                  binaryMessage.sublist(index * 8, (index + 1) * 8)),
              radix: 2)));

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
