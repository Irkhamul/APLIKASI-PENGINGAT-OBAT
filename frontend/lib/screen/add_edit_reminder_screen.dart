import 'package:flutter/material.dart';
import 'package:frontend/service/reminders.dart';
import 'package:frontend/service/medicine.dart';
import 'package:frontend/models/reminder.dart';
import 'package:frontend/models/medicine.dart';

class AddEditReminderScreen extends StatefulWidget {
  final Reminder? reminder;
  final Medicine? selectedMedicine;

  const AddEditReminderScreen({
    super.key,
    this.reminder,
    this.selectedMedicine,
  });

  @override
  State<AddEditReminderScreen> createState() => _AddEditReminderScreenState();
}

class _AddEditReminderScreenState extends State<AddEditReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _doseController = TextEditingController();
  DateTime? _reminderDate;
  TimeOfDay? _reminderTime;
  bool _isLoading = false;
  Medicine? _selectedMedicine;
  late Future<List<Medicine>> _medicines;

  @override
  void initState() {
    super.initState();
    _medicines = MedicineService().fetchMedicines();
    if (widget.reminder != null) {
      _nameController.text = widget.reminder!.name;
      _doseController.text = widget.reminder!.dose;
      _reminderDate = widget.reminder!.time;
      _reminderTime = TimeOfDay(
        hour: widget.reminder!.time.hour,
        minute: widget.reminder!.time.minute,
      );
      _selectedMedicine = widget.selectedMedicine;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.reminder == null ? 'Add Reminder' : 'Edit Reminder'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Medicine Dropdown
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
                    return DropdownButtonFormField<Medicine>(
                      value: _selectedMedicine,
                      decoration: const InputDecoration(
                        labelText: 'Select Medicine',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      ),
                      items: snapshot.data!.map((medicine) {
                        return DropdownMenuItem<Medicine>(
                          value: medicine,
                          child: Text(medicine.name),
                        );
                      }).toList(),
                      onChanged: (medicine) {
                        setState(() {
                          _selectedMedicine = medicine;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Please select a medicine' : null,
                    );
                  }
                },
              ),
              const SizedBox(height: 24),
              
              // Reminder Name
              _buildTextField(
                controller: _nameController,
                labelText: 'Reminder Name',
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter reminder name' : null,
              ),
              const SizedBox(height: 16),

              // Dose
              _buildTextField(
                controller: _doseController,
                labelText: 'Dose',
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter dose' : null,
              ),
              const SizedBox(height: 24),

              // Reminder Date
              _buildDateTimeTile(
                title: 'Reminder Date',
                value: _reminderDate != null
                    ? '${_reminderDate!.day}/${_reminderDate!.month}/${_reminderDate!.year}'
                    : 'Set date',
                icon: Icons.calendar_today,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _reminderDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() => _reminderDate = date);
                  }
                },
              ),
              const SizedBox(height: 24),

              // Reminder Time
              _buildDateTimeTile(
                title: 'Reminder Time',
                value: _reminderTime != null
                    ? '${_reminderTime!.hour}:${_reminderTime!.minute.toString().padLeft(2, '0')}'
                    : 'Set time',
                icon: Icons.access_time,
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: _reminderTime ?? TimeOfDay.now(),
                  );
                  if (time != null) {
                    setState(() => _reminderTime = time);
                  }
                },
              ),
              const SizedBox(height: 24),

              // Submit Button
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      ),
      validator: validator,
    );
  }

  Widget _buildDateTimeTile({
    required String title,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(value),
      trailing: Icon(icon),
      onTap: onTap,
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading
            ? null
            : () async {
                if (_reminderDate == null || _reminderTime == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please set a reminder date and time'),
                    ),
                  );
                  return;
                }

                if (_formKey.currentState!.validate()) {
                  setState(() => _isLoading = true);
                  try {
                    final reminder = Reminder(
                      id: widget.reminder?.id ?? 0,
                      medicineId: _selectedMedicine?.id ?? widget.reminder?.medicineId ?? 0,
                      name: _nameController.text,
                      dose: _doseController.text,
                      time: DateTime(
                        _reminderDate!.year,
                        _reminderDate!.month,
                        _reminderDate!.day,
                        _reminderTime!.hour,
                        _reminderTime!.minute,
                      ),
                      createdAt: widget.reminder?.createdAt,
                      updatedAt: DateTime.now(),
                    );

                    if (widget.reminder != null) {
                      await ReminderService().updateReminder(
                        widget.reminder!.id,
                        reminder,
                      );
                    } else {
                      await ReminderService().addReminder(reminder);
                    }

                    Navigator.pop(context, true);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  } finally {
                    setState(() => _isLoading = false);
                  }
                }
              },
              style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.teal, // Consistent color theme
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                widget.reminder == null
                    ? 'Add Reminder'
                    : 'Save Changes',
                style: const TextStyle(fontSize: 16),
              ),
      ),
    );
  }
}