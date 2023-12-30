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
        title: Row(
          children: [
            Image.asset(
              'assets/ICON STEGLOCK.png',  // Sesuaikan dengan path ikon Anda
              height: 60,  // Sesuaikan dengan ukuran yang diinginkan
              width: 60,
            ),
            SizedBox(width: 8), // Jarak antara ikon dan teks
            Text('StegLock'),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/BG STEGLOCK3.png'), // Ganti dengan path gambar yang sesuai
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
                child: Text('Encode'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DecodePage()),
                  );
                },
                child: Text('Decode'),
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