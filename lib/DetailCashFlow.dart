// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'DatabaseHelper.dart';

class DetailCashFlow extends StatefulWidget {
  const DetailCashFlow({Key? key}) : super(key: key);

  @override
  _DetailCashFlowState createState() => _DetailCashFlowState();
}

class _DetailCashFlowState extends State<DetailCashFlow> {
  DatabaseHelper dbHelper = DatabaseHelper();

  late Future<List<Income>> incomes;
  late Future<List<Outcome>> outcomes;

  @override
  void initState() {
    super.initState();
    incomes = dbHelper.getAllIncomes();
    outcomes = dbHelper.getAllOutcomes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Cash Flow'),
      ),
      body: FutureBuilder<List<Income>>(
        future: incomes,
        builder: (context, incomeSnapshot) {
          return FutureBuilder<List<Outcome>>(
            future: outcomes,
            builder: (context, outcomeSnapshot) {
              if (incomeSnapshot.connectionState == ConnectionState.waiting ||
                  outcomeSnapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (incomeSnapshot.hasError || outcomeSnapshot.hasError) {
                return Text(
                    'Error: ${incomeSnapshot.error ?? outcomeSnapshot.error}');
              } else if ((!incomeSnapshot.hasData ||
                      incomeSnapshot.data!.isEmpty) &&
                  (!outcomeSnapshot.hasData || outcomeSnapshot.data!.isEmpty)) {
                return Text('Tidak ada data pemasukkan dan pengeluaran.');
              } else {
                final List<Income> incomeData = incomeSnapshot.data ?? [];
                final List<Outcome> outcomeData = outcomeSnapshot.data ?? [];

                // Combine incomeData and outcomeData as needed
                List<dynamic> combinedData = [...incomeData, ...outcomeData];

                // Sort combinedData by tanggal
                combinedData.sort((a, b) {
                  return a.tanggal.compareTo(b.tanggal);
                });

                // Tampilkan data dalam daftar DetailItem
                return ListView.builder(
                  itemCount: combinedData.length,
                  itemBuilder: (context, index) {
                    var item = combinedData[index];
                    return DetailItem(
                      tanggal: item.tanggal,
                      nominal: item is Income
                          ? item.nominal.toStringAsFixed(2)
                          : '-${item.nominal.toStringAsFixed(2)}', // Use '-' for outcomes
                      keterangan: item.keterangan,
                      isIncome: item
                          is Income, // Pass isIncome based on the item type
                    );
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}

class DetailItem extends StatelessWidget {
  final String tanggal;
  final String nominal;
  final String keterangan;
  final bool isIncome; // Add this field

  // Add isIncome parameter to the constructor
  const DetailItem({
    required this.tanggal,
    required this.nominal,
    required this.keterangan,
    required this.isIncome,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isIncome
              ? Colors.green
              : Colors.red, // Use green for income and red for expenses
          child: Icon(
            isIncome
                ? Icons.arrow_back
                : Icons
                    .arrow_forward, // Use different icons for income and expenses
            color: Colors.white,
          ),
        ),
        title: Text('Tanggal: $tanggal'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Nominal: Rp $nominal'),
            Text('Keterangan: $keterangan'),
          ],
        ),
      ),
    );
  }
}

// ...

void main() {
  runApp(const MaterialApp(
    home: DetailCashFlow(),
  ));
}
