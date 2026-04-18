import 'package:flutter/material.dart';
import '../database/db_sanpham.dart';
import '../model/sanpham.dart';

class SanPhamProvider extends ChangeNotifier {
  List<SanPham> _dsSanPham = [];
  List<SanPham> get dsSanPham => _dsSanPham;

  Future<void> loadSanPhams() async {
    _dsSanPham = await DatabaseHelper().getSanPhams();
    notifyListeners();
  }

  Future<void> addSanPham(SanPham sp) async {
    await DatabaseHelper().insertSanPham(sp);
    await loadSanPhams();
  }

  Future<void> deleteSanPham(String id) async {
    await DatabaseHelper().deleteSanPham(id);
    await loadSanPhams();
  }
}
