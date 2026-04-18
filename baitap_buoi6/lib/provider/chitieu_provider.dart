import 'package:flutter/material.dart';
import '../database/db_chitieu.dart';
import '../model/chitieu.dart';

class ChiTieuProvider extends ChangeNotifier {
  List<ChiTieu> _dsChiTieu = [];
  List<ChiTieu> get dsChiTieu => _dsChiTieu;

  // Tính tổng số tiền chi tiêu để hiển thị ở bottom bar
  double get tongChiTieu =>
      _dsChiTieu.fold(0, (sum, item) => sum + item.sotien);

  Future<void> loadChiTieus() async {
    _dsChiTieu = await DatabaseHelper().getChiTieus();
    notifyListeners();
  }

  Future<void> addChiTieu(ChiTieu ct) async {
    await DatabaseHelper().insertChiTieu(ct);
    await loadChiTieus();
  }

  Future<void> deleteChiTieu(int id) async {
    await DatabaseHelper().deleteChiTieu(id);
    await loadChiTieus();
  }
}
