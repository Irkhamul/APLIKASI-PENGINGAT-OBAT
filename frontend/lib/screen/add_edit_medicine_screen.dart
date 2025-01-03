import 'package:flutter/material.dart';
import 'package:frontend/service/medicine.dart';
import 'package:frontend/models/medicine.dart';

class AddEditMedicineScreen extends StatefulWidget {
  final Medicine? medicine;

  const AddEditMedicineScreen({super.key, this.medicine});

  @override
  State<AddEditMedicineScreen> createState() => _AddEditMedicineScreenState();
}

class _AddEditMedicineScreenState extends State<AddEditMedicineScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _manufacturerController = TextEditingController();
  final _expiryDateController = TextEditingController();
  DateTime? _expiryDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.medicine != null) {
      _nameController.text = widget.medicine!.name;
      _descriptionController.text = widget.medicine!.description;
      _manufacturerController.text = widget.medicine!.manufacturer;
      _expiryDate = widget.medicine!.expiryDate;
      _expiryDateController.text = _expiryDate != null
          ? '${_expiryDate!.day}/${_expiryDate!.month}/${_expiryDate!.year}'
          : '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.medicine == null ? 'Add Medicine' : 'Edit Medicine'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                controller: _nameController,
                label: 'Medicine Name',
                icon: Icons.medical_services,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter medicine name' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _descriptionController,
                label: 'Description',
                icon: Icons.description,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _manufacturerController,
                label: 'Manufacturer',
                icon: Icons.business,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter manufacturer' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _expiryDateController,
                label: 'Expiry Date',
                icon: Icons.calendar_today,
                readOnly: true,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _expiryDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() {
                      _expiryDate = date;
                      _expiryDateController.text =
                          '${date.day}/${date.month}/${date.year}';
                    });
                  }
                },
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please select expiry date' : null,
              ),
              const SizedBox(height: 24),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
    int? maxLines,
    Function()? onTap,
    String? Function(String?)? validator,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        maxLines: maxLines,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.blueAccent),
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading
            ? null
            : () async {
                if (_formKey.currentState!.validate()) {
                  setState(() => _isLoading = true);
                  try {
                    final medicine = Medicine(
                      id: widget.medicine?.id ?? 0,
                      name: _nameController.text,
                      description: _descriptionController.text,
                      manufacturer: _manufacturerController.text,
                      expiryDate: _expiryDate!,
                    );

                    if (widget.medicine != null) {
                      await MedicineService().updateMedicine(
                        widget.medicine!.id,
                        medicine,
                      );
                    } else {
                      await MedicineService().addMedicine(medicine);
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ), backgroundColor: Colors.blueAccent,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: _isLoading
            ? const CircularProgressIndicator()
            : Text(
                widget.medicine == null ? 'Add Medicine' : 'Save Changes',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
      ),
    );
  }
}
