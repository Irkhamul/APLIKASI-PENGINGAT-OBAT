import 'package:flutter/material.dart';
import 'package:frontend/screen/login_screen.dart';
import 'package:frontend/service/auth.dart';
import 'package:frontend/service/medicine.dart';
import 'package:frontend/service/reminders.dart';
import 'package:frontend/models/medicine.dart';
import 'package:frontend/models/reminder.dart';
import 'add_edit_medicine_screen.dart';
import 'add_edit_reminder_screen.dart';
import 'medicine_detail_screen.dart';
import 'reminder_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Medicine>> _medicines;
  late Future<List<Reminder>> _reminders;

  @override
  void initState() {
    super.initState();
    _medicines = MedicineService().fetchMedicines();
    _reminders = ReminderService().fetchReminders();
  }

  Future<void> _logout() async {
    await logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home', style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        elevation: 4.0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[100],
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Medicines',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: Colors.blueGrey),
              ),
              const SizedBox(height: 10),
              FutureBuilder<List<Medicine>>(
                future: _medicines,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No medicines found.'));
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final medicine = snapshot.data![index];
                        return Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 4.0,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            title: Text(
                              medicine.name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            subtitle: Text(
                              medicine.description,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MedicineDetailScreen(medicine: medicine),
                                ),
                              );
                            },
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddEditMedicineScreen(medicine: medicine),
                                      ),
                                    );
                                    if (result == true) {
                                      setState(() {
                                        _medicines = MedicineService().fetchMedicines();
                                      });
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () async {
                                    await MedicineService().deleteMedicine(medicine.id);
                                    setState(() {
                                      _medicines = MedicineService().fetchMedicines();
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddEditMedicineScreen()),
                  );
                  if (result == true) {
                    setState(() {
                      _medicines = MedicineService().fetchMedicines();
                    });
                  }
                },
                child: const Text('Add Medicine', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 40),
              const Text(
                'Reminders',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: Colors.blueGrey),
              ),
              const SizedBox(height: 10),
              FutureBuilder<List<Reminder>>(
                future: _reminders,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No reminders found.'));
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final reminder = snapshot.data![index];
                        return Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 4.0,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            title: Text(
                              reminder.name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            subtitle: Text(
                              '${reminder.dose} at ${reminder.time.hour}:${reminder.time.minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReminderDetailScreen(reminder: reminder),
                                ),
                              );
                            },
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddEditReminderScreen(reminder: reminder),
                                      ),
                                    );
                                    if (result == true) {
                                      setState(() {
                                        _reminders = ReminderService().fetchReminders();
                                      });
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () async {
                                    await ReminderService().deleteReminder(reminder.id);
                                    setState(() {
                                      _reminders = ReminderService().fetchReminders();
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddEditReminderScreen()),
                  );
                  if (result == true) {
                    setState(() {
                      _reminders = ReminderService().fetchReminders();
                    });
                  }
                },
                child: const Text('Add Reminder', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
