import 'package:vania/vania.dart';
import 'package:backend/app/models/medicine.dart';

class MedicineController extends Controller {
  
  // Menambahkan obat baru
  Future<Response> create(Request request) async {
    // Validasi input
    request.validate({
      'name': 'required|string|max_length:50',
      'description': 'required|string',
      'manufacturer': 'required|string|max_length:50',
      'expiry_date': 'required|date',
    });

    final medicineData = request.input();

    // Cek apakah obat dengan nama yang sama sudah ada
    final existingMedicine = await Medicine()
        .query()
        .where('name', '=', medicineData['name'])
        .first();

    if (existingMedicine != null) {
      return Response.json(
        {'message': 'Obat dengan nama ini sudah ada.'},
        409,
      );
    }

    // Tambahkan waktu pembuatan
    medicineData['created_at'] = DateTime.now().toIso8601String();

    // Simpan ke database
    await Medicine().query().insert(medicineData);

    return Response.json(
      {
        'message': 'Obat berhasil ditambahkan.',
        'data': medicineData,
      },
      201,
    );
  }
// Mendapatkan obat berdasarkan ID
Future<Response> get(Request request,int id) async {
  // Cari obat berdasarkan ID
  final medicine = await Medicine().query().where('id', '=', id).first();

  // Jika data obat tidak ditemukan
  if (medicine == null) {
    return Response.json({'message': 'Obat dengan ID tersebut tidak ditemukan.'}, 404);
  }

  // Jika ditemukan, kembalikan data obat
  return Response.json({'data': medicine}, 200);
}

  // Mendapatkan semua obat
  Future<Response> show() async {
    final medicines = await Medicine().query().get();
    return Response.json({'data': medicines});
  }

  // Memperbarui data obat
  Future<Response> update(Request request, int id) async {
    // Validasi input
    request.validate({
      'name': 'required|string|max_length:50',
      'description': 'required|string',
      'manufacturer': 'required|string|max_length:50',
      'expiry_date': 'required|date',
    });

    final medicineData = request.input();
    medicineData['updated_at'] = DateTime.now().toIso8601String();

    // Periksa ID obat
    final medicine = await Medicine().query().where('id', '=', id).first();

    if (medicine == null) {
      return Response.json({'message': 'Obat dengan ID tersebut tidak ditemukan.'}, 404);
    }

    // Update data obat
    await Medicine().query().where('id', '=', id).update({
      'name': medicineData['name'],
      'description': medicineData['description'],
      'manufacturer': medicineData['manufacturer'],
      'expiry_date': medicineData['expiry_date'],
      'updated_at': medicineData['updated_at'],
    });

    return Response.json({
      'message': 'Obat berhasil diperbarui.',
      'data': medicineData,
    }, 200);
  }

  // Menghapus obat
  Future<Response> delete(int id) async {
    final deleted = await Medicine().query().where('id', '=', id).delete();

    if (deleted == 0) {
      return Response.json({'message': 'Obat tidak ditemukan.'}, 404);
    }

    return Response.json({'message': 'Obat berhasil dihapus.'});
  }
}

final MedicineController medicineController = MedicineController();