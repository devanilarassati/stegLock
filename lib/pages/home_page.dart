import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:steglock2/pages/decode_page.dart';
import 'package:steglock2/pages/encode_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _grantPermission();
  }

  @override
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 203, 148, 212),
        title: Row(
          children: [
            Icon(
              Icons.lock,
              color: Colors.white,
              size: 32,
            ),
            SizedBox(width: 8), 
            Text('StegLock'),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/BG STEGLOCK3.png'), 
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EncodePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 203, 148, 212), // Ganti dengan warna ungu yang diinginkan
              ),
                child: Text('Encode', style: TextStyle(
                  color: Colors.black, // Ganti dengan warna teks yang diinginkan
                ),),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DecodePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 203, 148, 212), // Ganti dengan warna ungu yang diinginkan
                ),
                child: Text('Decode', style: TextStyle(
                  color: Colors.black, // Ganti dengan warna teks yang diinginkan
                ),),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _grantPermission () async {
    var status = await Permission.storage.status;
    if (status.isGranted) {

    } else {
      await Permission.storage.request();
      status = await Permission.storage.status;
      print(status);
    }
 }
}