import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:steganograph/steganograph.dart';


class DecodePage extends StatefulWidget {
  @override
  _DecodePageState createState() => _DecodePageState();
}

class _DecodePageState extends State<DecodePage> {
  File? _imageFile;
  bool _passwordVisible = false;
  String _hiddenMessage = "";
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 203, 148, 212),
        title: Text('Steganography'),
      ),
      body: Expanded(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 203, 148, 212), // Ganti dengan warna ungu yang diinginkan
                  ),
                  child: Text('Choose Image', style: TextStyle(
                  color: Colors.black, // Ganti dengan warna teks yang diinginkan
                ),),
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
                  controller: _passwordController,
                  obscureText: !_passwordVisible,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: 'Enter Password',
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                      child: Container(
                          margin: const EdgeInsets.all(13),
                          child: Icon(
                              this._passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                              size: 25)),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _hideMessage,
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 203, 148, 212), // Ganti dengan warna ungu yang diinginkan
                  ),
                  child: Text('Show Message', style: TextStyle(
                  color: Colors.black, // Ganti dengan warna teks yang diinginkan
                ),),
                ),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Clipboard.setData(
                        ClipboardData(text: _hiddenMessage ?? ""));
                  },
                  child: Text('Hidden Message:\n${_hiddenMessage}', style: TextStyle(
                  color: Colors.black, // Ganti dengan warna teks yang diinginkan
                ),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    // Only PNG allowed for steganography
    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['png'],
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.paths.first!);
      });
    }
  }

  Future<void> _hideMessage() async {
    if (_imageFile == null) {
      return;
    }

    //decode with same encryption key used to encode
    //to retrieve encrypted message
    String? embeddedMessage = await Steganograph.decode(
      image: File(_imageFile!.path),
      encryptionKey: _passwordController.text,
    );

    setState(() {
      _hiddenMessage = embeddedMessage ?? "No hidden information found in image.";
    });
  }
}
