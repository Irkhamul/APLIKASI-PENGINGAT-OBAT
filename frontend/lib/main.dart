import 'package:flutter/material.dart';
import 'package:frontend/screen/splash_screen.dart';
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
          primary: Colors.deepPurple,
          secondary: Colors.deepPurple.shade300,
          tertiary: Colors.deepPurple.shade100,
        ),
        useMaterial3: true,
        // Memperbarui gaya teks
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
          headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.25,
          ),
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.15,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            letterSpacing: 0.15,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            letterSpacing: 0.25,
          ),
        ),
        // Memperbarui dekorasi input
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
            borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          prefixIconColor: Colors.deepPurple,
          suffixIconColor: Colors.deepPurple,
        ),
        // Memperbarui tema tombol
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
            elevation: 2,
          ),
        ),
        // Memperbarui tema kartu
        cardTheme: CardTheme(
          elevation: 3,
          shadowColor: Colors.deepPurple.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        ),
        // Menambahkan tema appbar
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.deepPurple,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.deepPurple,
          ),
        ),
      ),
      
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
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