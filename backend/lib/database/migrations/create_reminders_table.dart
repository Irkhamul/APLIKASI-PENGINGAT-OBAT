import 'package:vania/vania.dart';

class CreateRemindersTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('reminders', () {
      primary('id'); // Primary key
      bigIncrements('id'); // Auto-increment big integer
      bigInt('user_id', unsigned: true); // Foreign key to users table
      bigInt('medicine_id', unsigned: true); // Foreign key to medicine table
      string('name'); // Name of the reminder
      string('dose'); // Dose of the medicine
      dateTime('time'); // Time of the reminder
      timeStamps(); // Created_at & updated_at timestamps
      foreign('user_id', 'users', 'id', constrained: true, onDelete: 'CASCADE'); // Foreign key constraint
      foreign('medicine_id', 'medicine', 'id', constrained: true, onDelete: 'CASCADE'); // Foreign key constraint
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('reminders'); // Drop the table if it exists
  }
}