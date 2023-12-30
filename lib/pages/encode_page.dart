import 'dart:io';
import 'package:external_path/external_path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
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
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                  child: Text('Hide Message'),
                ),
                // SizedBox(height: 16),
                // TextButton(
                //   onPressed: () {
                //     Clipboard.setData(ClipboardData(text: _key));
                //   },
                //   child: Text('Key: ${_key}'),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
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

    // ecryption and steganography the message
    String extPath = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);
    final imagePath = extPath + "/steglock_" + Path.basename(_imageFile!.path);
    debugPrint(
        '${_messageController.text} ----- ${_passwordController.text} --- ${imagePath}');
    // await imageFile?.copy(imagePath);
    File? file = await Steganograph.encode(
      image: File(_imageFile!.path),
      message: _messageController.text,
      encryptionKey: _passwordController.text,
      outputFilePath: extPath + "/steglock_" + Path.basename(_imageFile!.path),
    );
    debugPrint(file!.path);
    Util.showInfoDialog(context, () {});
  }
}
