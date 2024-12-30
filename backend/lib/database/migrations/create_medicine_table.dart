import 'package:vania/vania.dart';

class CreateMedicineTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('medicine', () {
      primary('id'); // Primary key
      bigIncrements('id'); // Auto-increment big integer
      string('name'); // Name of the medicine
      string('description'); // Description of the medicine
      string('manufacturer'); // Manufacturer of the medicine
      dateTime('expiry_date'); // Expiry date of the medicine
      timeStamps(); // Created_at & updated_at timestamps
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('medicine'); // Drop the table if it exists
  }
}