// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'DatabaseHelper.dart';

class TambahPengeluaran extends StatefulWidget {
  const TambahPengeluaran({Key? key}) : super(key: key);

  @override
  _TambahPengeluaranState createState() => _TambahPengeluaranState();
}

class _TambahPengeluaranState extends State<TambahPengeluaran> {
  // Definisikan controller untuk mengambil nilai input dari pengguna.
  final TextEditingController idController = TextEditingController();
  final TextEditingController tanggalController = TextEditingController();
  final TextEditingController nominalController = TextEditingController();
  final TextEditingController keteranganController = TextEditingController();

  DatabaseHelper dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Pengeluaran'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: idController,
              decoration: const InputDecoration(labelText: 'ID'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: tanggalController,
              decoration:
                  const InputDecoration(labelText: 'Tanggal Pengeluaran'),
            ),
            TextField(
              controller: nominalController,
              decoration: const InputDecoration(labelText: 'Nominal Rp.'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: keteranganController,
              decoration: const InputDecoration(labelText: 'Keterangan'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                int id = int.tryParse(idController.text) ?? 0;
                String tanggal = tanggalController.text;
                double nominal = double.tryParse(nominalController.text) ?? 0.0;
                String keterangan = keteranganController.text;

                // Validasi input.
                if (tanggal.isEmpty || nominal <= 0) {
                  // Tampilkan pesan kesalahan jika ada input yang tidak valid.
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: const Text(
                            'Tanggal dan nominal harus diisi dengan benar.'),
                        actions: [
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
                } else {
                  // Input valid, tambahkan ke database.
                  Outcome newOutcome = Outcome(
                      id: id,
                      tanggal: tanggal,
                      nominal: nominal,
                      keterangan: keterangan);
                  await dbHelper.insertOutcome(newOutcome);

                  // Kembali ke halaman sebelumnya setelah menambahkan
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
