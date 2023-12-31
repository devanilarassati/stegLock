import 'dart:io';
import 'package:external_path/external_path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:igodo/igodo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:steganograph/steganograph.dart';
import 'package:steglock2/supports/util.dart';
import 'package:path/path.dart' as Path;

class EncodePage extends StatefulWidget {
  @override
  _EncodePageState createState() => _EncodePageState();
}


class _EncodePageState extends State<EncodePage> {
  File? _imageFile;
  bool _passwordVisible = false;
  String _encryptedMessage = "";
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Set<String> usedKeys = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         backgroundColor: Color.fromARGB(255, 203, 148, 212),
        title: Text('Steganography'),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 203, 148, 212), 
                  ),
                  child: Text('Choose Image', style: TextStyle(
                  color: Colors.black, 
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
                  controller: _messageController,
                  minLines: 3,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(labelText: 'Enter Message'),
                ),
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
                    primary: Color.fromARGB(255, 203, 148, 212), 
                  ),
                  child: Text('Hide Message', style: TextStyle(
                  color: Colors.black, 
                ),),
                ),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: _encryptedMessage));
                  },
                  child: Text('Encrypted Message:\n${_encryptedMessage}', style: TextStyle(
                  color: Colors.black, 
                ),),
                ),
              ],
            ),
          ),
        ),),
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
        // Reset the message when a new image is picked
        _messageController.text = '';
      });
    }
  }

  Future<void> _hideMessage() async {
    if (_imageFile == null) {
      return;
    }

  // Validate the character length of messages and passwords
  if (_messageController.text.length != _passwordController.text.length) {
    Util.showInfoDialog(context, "Message and password must have the same length.", () {});
    return;
  }

  if (usedKeys.contains(_passwordController.text)) {
      Util.showInfoDialog(context, "Password can only be used once.", () {});
      return;
    }

  if (_passwordController.text.toLowerCase() == _messageController.text.toLowerCase()) {
      Util.showInfoDialog(context, "Password cannot contain the same word as the message.", () {});
      return;
    }

    // Get path download directory
    String extPath = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);

    String outputFile =
        '${extPath}/steglock_${Util.generateKey(7)}_${Path.basename(_imageFile!.path)}';

    // ecnryption and steganography. File save in download directory
    File? file = await Steganograph.encode(
      image: File(_imageFile!.path),
      message: _messageController.text,
      encryptionKey: _passwordController.text,
      outputFilePath: outputFile,
    );

    // Show the encrupted message
    setState(() {
      _encryptedMessage =
          Igodo.encrypt(_messageController.text, _passwordController.text);
    });


  // Tambahkan kunci ke dalam daftar kunci yang telah digunakan
    usedKeys.add(_passwordController.text);

    Util.showInfoDialog(
        context, "Steganography file saved in Downloads directory.", () {});
  }
}
