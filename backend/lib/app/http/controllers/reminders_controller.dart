import 'package:vania/vania.dart';
import 'package:backend/app/models/reminders.dart';

class RemindersController extends Controller {
  
  // Menambahkan pengingat baru
  Future<Response> create(Request request) async {
    // Validasi input
    request.validate({
      'medicine_id': 'required|numeric',
      'name': 'required|string|max_length:50',
      'dose': 'required|string|max_length:50',
      'time': 'required|date_time',
    });

    final reminderData = request.input();

    // Tambahkan waktu pembuatan
    reminderData['created_at'] = DateTime.now().toIso8601String();

    // Simpan ke database
    await Reminders().query().insert(reminderData);

    return Response.json(
      {
        'message': 'Pengingat berhasil ditambahkan.',
        'data': reminderData,
      },
      201,
    );
  }

  // Mendapatkan semua pengingat
  Future<Response> show() async {
    final reminders = await Reminders().query().get();
    return Response.json({'data': reminders});
  }

  // Memperbarui data pengingat
  Future<Response> update(Request request, int id) async {
    // Validasi input
    request.validate({
      'medicine_id': 'required|numeric',
      'name': 'required|string|max_length:50',
      'dose': 'required|string|max_length:50',
      'time': 'required|date_time',
    });

    final reminderData = request.input();
    reminderData['updated_at'] = DateTime.now().toIso8601String();

    // Periksa ID pengingat
    final reminder = await Reminders().query().where('id', '=', id).first();

    if (reminder == null) {
      return Response.json({'message': 'Pengingat dengan ID tersebut tidak ditemukan.'}, 404);
    }

    // Update data pengingat
    await Reminders().query().where('id', '=', id).update({
      'medicine_id': reminderData['medicine_id'],
      'name': reminderData['name'],
      'dose': reminderData['dose'],
      'time': reminderData['time'],
      'updated_at': reminderData['updated_at'],
    });

    return Response.json({
      'message': 'Pengingat berhasil diperbarui.',
      'data': reminderData,
    }, 200);
  }

  // Menghapus pengingat
  Future<Response> delete(int id) async {
    final deleted = await Reminders().query().where('id', '=', id).delete();

    if (deleted == 0) {
      return Response.json({'message': 'Pengingat tidak ditemukan.'}, 404);
    }

    return Response.json({'message': 'Pengingat berhasil dihapus.'});
  }
}

final RemindersController remindersController = RemindersController();
