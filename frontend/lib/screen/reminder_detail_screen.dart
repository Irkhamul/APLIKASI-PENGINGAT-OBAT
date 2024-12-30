import 'package:flutter/material.dart';
import 'package:frontend/models/reminder.dart';
import 'package:frontend/service/medicine.dart';
import 'package:frontend/models/medicine.dart';

class ReminderDetailScreen extends StatefulWidget {
  final Reminder reminder;

  const ReminderDetailScreen({super.key, required this.reminder});

  @override
  State<ReminderDetailScreen> createState() => _ReminderDetailScreenState();
}

class _ReminderDetailScreenState extends State<ReminderDetailScreen> {
  late Future<Medicine> _medicine;

  @override
  void initState() {
    super.initState();
    _medicine = MedicineService().fetchMedicineById(widget.reminder.medicineId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.reminder.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nama Obat:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            FutureBuilder<Medicine>(
              future: _medicine,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData) {
                  return const Text('Obat tidak ditemukan.');
                } else {
                  return TextFormField(
                    initialValue: snapshot.data!.name,
                    readOnly: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Dosis:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: widget.reminder.dose,
              readOnly: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Waktu:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: '${widget.reminder.time.hour}:${widget.reminder.time.minute.toString().padLeft(2, '0')}',
              readOnly: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}