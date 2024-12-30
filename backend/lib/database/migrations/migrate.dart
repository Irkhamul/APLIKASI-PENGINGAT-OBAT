import 'dart:io';
import 'package:vania/vania.dart';
import 'create_users_table.dart';
import 'create_reminders_table.dart';
import 'create_medicine_table.dart';
import 'create_personal_access_tokens_table.dart';

void main(List<String> args) async {
  await MigrationConnection().setup();
  if (args.isNotEmpty && args.first.toLowerCase() == "migrate:fresh") {
    await Migrate().dropTables();
  } else {
    await Migrate().registry();
  }
  await MigrationConnection().closeConnection();
  exit(0);
}

class Migrate {
  registry() async {
		 await CreateUserTable().up();
		 await CreateRemindersTable().up();
		 await CreateMedicineTable().up();
		 await CreatePersonalAccessTokensTable().up();
	}

  dropTables() async {
		 await CreatePersonalAccessTokensTable().down();
		  await CreateMedicineTable().down();
		 await CreateRemindersTable().down();
		 await CreateUserTable().down();
	 }
}
