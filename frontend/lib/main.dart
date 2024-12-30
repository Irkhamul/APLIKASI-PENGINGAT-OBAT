import 'package:flutter/material.dart';
import 'package:frontend/screen/login_screen.dart';
import 'package:frontend/screen/register_screen.dart';
import 'package:frontend/screen/home_screen.dart';
import 'package:frontend/screen/add_edit_medicine_screen.dart';
import 'package:frontend/screen/add_edit_reminder_screen.dart';
import 'package:frontend/screen/medicine_detail_screen.dart';
import 'package:frontend/screen/reminder_detail_screen.dart';
import 'package:frontend/models/medicine.dart';
import 'package:frontend/models/reminder.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medicine Reminder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        // Tambahkan gaya teks yang konsisten
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        // Sesuaikan dekorasi input
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.deepPurple),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        // Sesuaikan tombol elevasi
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        // Sesuaikan tema kartu
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
        ),
      ),
      // Definisikan rute bernama
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/add_medicine': (context) => const AddEditMedicineScreen(),
        '/edit_medicine': (context) => AddEditMedicineScreen(
              medicine: ModalRoute.of(context)!.settings.arguments != null
                  ? Medicine.fromJson(ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)
                  : null,
            ),
        '/add_reminder': (context) => const AddEditReminderScreen(),
        '/edit_reminder': (context) => AddEditReminderScreen(
              reminder: ModalRoute.of(context)!.settings.arguments != null
                  ? Reminder.fromJson(ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)
                  : null,
            ),
        '/medicine_detail': (context) => MedicineDetailScreen(
              medicine: ModalRoute.of(context)!.settings.arguments as Medicine,
            ),
        '/reminder_detail': (context) => ReminderDetailScreen(
              reminder: ModalRoute.of(context)!.settings.arguments as Reminder,
            ),
      },
    );
  }
}