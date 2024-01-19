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
              SizedBox(height: 35),
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _showHelpDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 203, 148, 212),
                ),
                child: Text(
                  'Help', // Teks yang ditampilkan pada tombol
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
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
  void _showHelpDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Cara Penggunaan Aplikasi StegLock',
        textAlign: TextAlign.center,),
        content: Padding(
          padding: const EdgeInsets.only(top: 16.0), // Tambahkan jarak di atas konten
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
                  Text('1.', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(width: 8),  // Tambahkan jarak antara nomor dan penjelasannya
                  Expanded(
                    child: Text('Klik tombol encode. Kemudian, klik tombol "Choose Image", pilih gambar berformat .png.'),
                  ),
                ],
              ),
                      Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('2.', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(width: 8),  // Tambahkan jarak antara nomor dan penjelasannya
                  Expanded(
                    child: Text('Masukkan pesan teks yang ingin disembunyikan.'),
                  ),
                ],
              ),
                      Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('3.', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(width: 8),  // Tambahkan jarak antara nomor dan penjelasannya
                  Expanded(
                    child: Text('Masukkan password untuk enkripsi dan encode. Pesan dan Password harus memiliki panjang karakter yang sama!'),
                  ),
                ],
              ),
                      Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('4.', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(width: 8),  // Tambahkan jarak antara nomor dan penjelasannya
                  Expanded(
                    child: Text('Tekan tombol "Hide Message" untuk menyembunyikan pesan.'),
                  ),
                ],
              ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('5.', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(width: 8),  // Tambahkan jarak antara nomor dan penjelasannya
                          Expanded(
                            child: Text('Pesan teks berhasil dienkripsi dan disisipkan pada gambar. File tersisipi tersimpan pada folder download smartphone'),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('6.', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(width: 8),  // Tambahkan jarak antara nomor dan penjelasannya
                          Expanded(
                            child: Text('Untuk mengambil informasi teks yang tersisipi pada gambar .png. Klik "choose image" dan pilih file gambar .png yang sudah tersisispi informasi teks'),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('7.', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(width: 8),  // Tambahkan jarak antara nomor dan penjelasannya
                          Expanded(
                            child: Text('Masukkan password yang sama seperti pada saat proses encode dan klik "show message". Maka akan muncul informasi teks yang tersembunyi.'),
                          ),
                        ],
                      ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Tutup'),
          ),
        ],
       // Atur contentPadding untuk memperkecil ukuran popup
        contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical:05.0),
      );
    },
  );
}
}