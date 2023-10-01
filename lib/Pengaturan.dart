import 'package:flutter/material.dart';
import 'DatabaseHelper.dart';
import 'package:flutter/material.dart';

class Pengaturan extends StatefulWidget {
  const Pengaturan({Key? key}) : super(key: key);

  @override
  _PengaturanState createState() => _PengaturanState();
}

class _PengaturanState extends State<Pengaturan> {
  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();

  String developerApp = "Aplikasi Pencatatan Keuangan Berkah Barokah";
  String developerCreatedby = "Aplikasi ini dibuat oleh:";
  String developerName = "Hamdan Daalal Fauzi";
  String developerNIM = "1941720148";
  String developerDate = "29 Oktober 2023";

  String currentPassword =
      "PasswordAnda"; // Ganti dengan password saat ini yang valid

  bool passwordMatch = true;

  void _changePassword() {
    if (_currentPasswordController.text == currentPassword) {
      // Password saat ini benar
      // Lakukan tindakan untuk menyimpan password baru di sini
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Password Berhasil Diubah'),
            content: Text('Password baru Anda telah disimpan.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Password saat ini salah
      setState(() {
        passwordMatch = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengaturan'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Ganti Password',
                style: TextStyle(
                  fontSize: 18, // Ubah ukuran teks sesuai kebutuhan
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Ubah warna teks sesuai kebutuhan
                ),
              ),
              TextField(
                controller: _currentPasswordController,
                decoration: InputDecoration(
                  labelText: 'Password Saat Ini',
                  errorText: passwordMatch ? null : 'Password tidak cocok',
                ),
                obscureText: true,
              ),
              TextField(
                controller: _newPasswordController,
                decoration: InputDecoration(labelText: 'Password Baru'),
                obscureText: true,
              ),
              ElevatedButton(
                onPressed: _changePassword,
                child: Text('Ubah Password'),
              ),
              SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          'https://exp.itemku.com/wp-content/uploads/2023/02/foto-naruto-cool.jpg',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(developerApp),
                        Text(developerCreatedby),
                        Text(developerName),
                        Text(developerNIM),
                        Text(developerDate),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
