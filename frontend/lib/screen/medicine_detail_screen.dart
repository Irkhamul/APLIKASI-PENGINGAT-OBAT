import 'package:flutter/material.dart';
import 'package:frontend/models/medicine.dart';

class MedicineDetailScreen extends StatelessWidget {
  final Medicine medicine;

  const MedicineDetailScreen({super.key, required this.medicine});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(medicine.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Description:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(medicine.description),
            const SizedBox(height: 16),
            const Text(
              'Manufacturer:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(medicine.manufacturer),
            const SizedBox(height: 16),
            const Text(
              'Expiry Date:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('${medicine.expiryDate.day}/${medicine.expiryDate.month}/${medicine.expiryDate.year}'),
          ],
        ),
      ),
    );
  }
}