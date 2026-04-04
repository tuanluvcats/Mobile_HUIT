import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../model/sinhvien.dart';

class SinhVienProvider extends ChangeNotifier {
  List<SinhVien> _sinhViens = [];
  List<SinhVien> get sinhViens => _sinhViens;
  Future<void> loadSinhViens() async {
    _sinhViens = await DatabaseHelper().getSinhViens();
    notifyListeners(); //để UI tự cập nhật
  }

  Future<void> addSinhVien(SinhVien sv) async {
    await DatabaseHelper().insertSinhVien(sv);
    loadSinhViens();
  }

  Future<void> deleteSinhVien(int id) async {
    await DatabaseHelper().deleteSinhVien(id);
    loadSinhViens();
  }

  Future<void> updateSinhVien(SinhVien sv) async {
    await DatabaseHelper().updateSinhVien(sv);
    loadSinhViens();
  }
}
