import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:bnsp_mobile/DetailCashFlow.dart';
import 'package:bnsp_mobile/TambahPemasukan.dart';
import 'DatabaseHelper.dart';
import 'TambahPengeluaran.dart';
import 'Pengaturan.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', // Rute awal adalah '/' (halaman login)
      routes: {
        '/': (context) => const LoginPage(),
        '/home': (context) => Beranda(), // Rute untuk halaman beranda
      },
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.center,
          child: Text('Halaman Login'),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: LoginForm(),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Align(
            alignment:
                Alignment.topCenter, // Mengatur gambar ke bagian atas tengah
            child: CircleAvatar(
              radius: 80, // Sesuaikan dengan ukuran yang Anda inginkan
              backgroundImage: NetworkImage(
                'https://w7.pngwing.com/pngs/1008/375/png-transparent-food-line-financial-concepts-food-logo-financial.png',
              ),
            ),
          ),
          const SizedBox(height: 30.0),
          const Text(
            'Aplikasi Pencatatan Keuangan Berkah Barokah',
            textAlign: TextAlign.center, // Untuk mengatur teks ke tengah
            style: TextStyle(
              fontSize: 25.0, // Sesuaikan ukuran teks dengan preferensi Anda
              fontWeight:
                  FontWeight.bold, // Sesuaikan gaya teks dengan preferensi Anda
            ),
          ),
          const SizedBox(height: 20.0),
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(labelText: 'Username'),
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              // Implementasi logika autentikasi di sini
              String username = _usernameController.text;
              String password = _passwordController.text;
              // Contoh sederhana, Anda harus menggantinya dengan logika autentikasi yang aman
              if (username == 'user' && password == 'user') {
                Navigator.of(context)
                    .pushReplacementNamed('/home'); // Ganti rute ke '/home'
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Login Gagal'),
                      content: const Text('Username atau password salah.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            child: const Text('Login'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity,
                  50), // Sesuaikan dengan lebar dan tinggi yang diinginkan
            ),
          ),
        ],
      ),
    );
  }
}

class Beranda extends StatelessWidget {
  Beranda({Key? key}) : super(key: key);

  DatabaseHelper dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rangkuman Bulan Hari Ini'),
        centerTitle: true, //Tulisan agar center ke tengah
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const Text(
              'Rangkuman Bulan Ini',
              style: TextStyle(
                fontSize: 22, // Mengatur warna teks menjadi merah
              ),
            ),

            FutureBuilder<List<double>>(
              future: Future.wait(
                  [dbHelper.getTotalIncome(), dbHelper.getTotalOutcome()]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('Loading...');
                } else {
                  double totalIncome = snapshot.data![0];
                  double totalOutcome = snapshot.data![1];
                  return Column(
                    children: <Widget>[
                      Text(
                        'Pengeluaran Rp. ${totalOutcome.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.red,
                        ),
                      ),
                      Text(
                        'Pemasukan Rp. ${totalIncome.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // Rest of your UI...
                    ],
                  );
                }
              },
            ),
            const SizedBox(
                height:
                    20), // Jarak antara pengeluaran dan pemasukan dengan gambar grafik
            Image.network(
              'https://www.bca.co.id/en/informasi/Edukatips/2021/11/01/03/45/-/media/Images/edukatips/2021/10/20211101-Edukatips-Welma-Jangka-Waktu-Investasi-1.png',
              fit: BoxFit.fill, // Mengatur gambar agar penuh secara lebar
              height: 250, // Mengatur tinggi gambar menjadi 150
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // Navigasi ke halaman "Tambah Pemasukan" saat gambar ditekan
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TambahPemasukan(),
                        ),
                      );
                    },
                    child: Column(
                      children: <Widget>[
                        Image.network(
                          'https://cdn.icon-icons.com/icons2/518/PNG/512/Incomeincrease_icon-icons.com_51148.png',
                          fit: BoxFit.cover, // Sesuaikan sesuai kebutuhan
                          height: 100, // Sesuaikan sesuai kebutuhan
                        ),
                        const SizedBox(
                            height: 10), // Jarak antara gambar dan teks
                        Text(
                          'Tambah Pemasukan ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10), // Jarak antara tombol
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // Navigasi ke halaman "Tambah Pengeluaran" saat gambar ditekan
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TambahPengeluaran(),
                        ),
                      );
                    },
                    child: Column(
                      children: <Widget>[
                        Image.network(
                          'https://cdn.icon-icons.com/icons2/518/PNG/512/Incomedecrease_icon-icons.com_51149.png',
                          fit: BoxFit.cover, // Sesuaikan sesuai kebutuhan
                          height: 100, // Sesuaikan sesuai kebutuhan
                        ),
                        const SizedBox(
                            height: 10), // Jarak antara gambar dan teks
                        Text(
                          'Tambah Pengeluaran',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // Navigasi ke halaman "Detail Cash Flow" saat gambar ditekan
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DetailCashFlow(),
                        ),
                      );
                    },
                    child: Column(
                      children: <Widget>[
                        Image.network(
                          'https://cdn-icons-png.flaticon.com/512/2751/2751615.png',
                          fit: BoxFit.cover,
                          height: 100,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Detail Cash Flow',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // Navigasi ke halaman "Pengaturan" saat gambar ditekan
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              Pengaturan(), // Ganti dengan halaman Pengaturan Anda
                        ),
                      );
                    },
                    child: Column(
                      children: <Widget>[
                        Image.network(
                          'https://cdn.icon-icons.com/icons2/2436/PNG/512/application_settings_icon_147478.png',
                          fit: BoxFit.cover,
                          height: 100,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Pengaturan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
