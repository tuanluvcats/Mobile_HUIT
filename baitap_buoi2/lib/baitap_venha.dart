import 'dart:io';

abstract class HoaDon {
  String _maKH = '';
  String _tenKH = '';
  int _soLuong = 0;
  double _giaBan = 0.0;

  HoaDon();

  HoaDon.full(String ma, String ten, int sl, double gia) {
    maKH = ma;
    tenKH = ten;
    soLuong = sl;
    giaBan = gia;
  }

  String get maKH => _maKH;
  set maKH(String value) {
    RegExp regex = RegExp(r'^KH\d{4}$');
    if (regex.hasMatch(value)) {
      _maKH = value;
    } else {
      print('Ma KH khong dung dinh dang (KHxxxx). Set mac dinh KH0000');
      _maKH = 'KH0000';
    }
  }

  String get tenKH => _tenKH;
  set tenKH(String value) {
    if (value.trim().isNotEmpty) {
      _tenKH = value;
    } else {
      print('Ten khong duoc de trong. Set mac dinh Unknow');
      _tenKH = 'Unknow';
    }
  }

  int get soLuong => _soLuong;
  set soLuong(int value) {
    if (value > 0) {
      _soLuong = value;
    } else {
      print('So luong phai > 0. Set mac dinh 1');
      _soLuong = 1;
    }
  }

  double get giaBan => _giaBan;
  set giaBan(double value) {
    if (value > 0) {
      _giaBan = value;
    } else {
      print('Gia ban phai > 0. Set mac dinh 1');
      _giaBan = 1;
    }
  }

  double tinhChietKhau();
  
  double tinhTroGia() {
    return 0;
  }

  double tinhThueVAT() {
    return 0.1 * _soLuong * _giaBan;
  }

  double tinhThanhTien() {
    return (_soLuong * _giaBan) - tinhChietKhau() + tinhThueVAT();
  }

  void nhapThongTin() {
    stdout.write('Nhap ma KH (KHxxxx): ');
    maKH = stdin.readLineSync() ?? '';
    
    stdout.write('Nhap ten KH: ');
    tenKH = stdin.readLineSync() ?? '';
    
    stdout.write('Nhap so luong: ');
    soLuong = int.tryParse(stdin.readLineSync() ?? '0') ?? 0;
    
    stdout.write('Nhap gia ban: ');
    giaBan = double.tryParse(stdin.readLineSync() ?? '0') ?? 0;
  }

  void xuatThongTin() {
    print(
      'Ma: $_maKH | Ten: $_tenKH | SL: $_soLuong | Gia: $_giaBan | '
      'CK: ${tinhChietKhau()} | TroGia: ${tinhTroGia()} | ThanhTien: ${tinhThanhTien()}'
    );
  }
}

class KhachHangCaNhan extends HoaDon {
  double _khoangCach = 0.0;

  KhachHangCaNhan() : super();

  KhachHangCaNhan.full(String ma, String ten, int sl, double gia, double kc)
      : super.full(ma, ten, sl, gia) {
    _khoangCach = kc;
  }

  @override
  void nhapThongTin() {
    super.nhapThongTin();
    stdout.write('Nhap khoang cach: ');
    _khoangCach = double.tryParse(stdin.readLineSync() ?? '0') ?? 0;
  }

  @override
  double tinhChietKhau() {
    double ck = 0;
    if (soLuong >= 3) {
      ck = 0.05 * giaBan * soLuong;
    }
    if (_khoangCach < 10) {
      ck += 50000 * soLuong;
    }
    return ck;
  }

  @override
  double tinhTroGia() {
    double troGia = 0.02 * giaBan * soLuong; 
    if (soLuong > 2) {
      troGia += 100000;
    }
    return troGia;
  }
}

class DaiLyCap1 extends HoaDon {
  int _thoiGianHopTac = 0;

  DaiLyCap1() : super();

  DaiLyCap1.full(String ma, String ten, int sl, double gia, int nam)
      : super.full(ma, ten, sl, gia) {
    _thoiGianHopTac = nam;
  }

  @override
  void nhapThongTin() {
    super.nhapThongTin();
    stdout.write('Nhap so nam hop tac: ');
    _thoiGianHopTac = int.tryParse(stdin.readLineSync() ?? '0') ?? 0;
  }

  @override
  double tinhChietKhau() {
    double tyLe = 0.30;
    if (_thoiGianHopTac > 5) {
      tyLe += (_thoiGianHopTac - 5) * 0.01;
    }
    if (tyLe > 0.35) {
      tyLe = 0.35;
    }
    return tyLe * giaBan * soLuong;
  }
}

class KhachHangCongTy extends HoaDon {
  int _soLuongNV = 0;

  KhachHangCongTy() : super();

  KhachHangCongTy.full(String ma, String ten, int sl, double gia, int nv)
      : super.full(ma, ten, sl, gia) {
    _soLuongNV = nv;
  }

  @override
  void nhapThongTin() {
    super.nhapThongTin();
    stdout.write('Nhap so luong nhan vien: ');
    _soLuongNV = int.tryParse(stdin.readLineSync() ?? '0') ?? 0;
  }

  @override
  double tinhChietKhau() {
    double tyLe = 0;
    if (_soLuongNV > 5000) {
      tyLe = 0.07;
    } else if (_soLuongNV > 1000) {
      tyLe = 0.05;
    }
    return tyLe * giaBan * soLuong;
  }

  @override
  double tinhTroGia() {
    return 120000.0 * soLuong;
  }
}

class QuanLyHoaDon {
  List<HoaDon> dsHoaDon = [];

  void nhapDanhSach() {
    stdout.write('Nhap so luong hoa don: ');
    int n = int.tryParse(stdin.readLineSync() ?? '0') ?? 0;
    for (int i = 0; i < n; i++) {
      print('Chon loai KH: 1.Ca Nhan, 2.Dai Ly, 3.Cong Ty');
      String? chon = stdin.readLineSync();
      HoaDon? hd;
      if (chon == '1') hd = KhachHangCaNhan();
      else if (chon == '2') hd = DaiLyCap1();
      else if (chon == '3') hd = KhachHangCongTy();

      if (hd != null) {
        hd.nhapThongTin();
        dsHoaDon.add(hd);
      }
    }
  }

  void xuatDanhSach() {
    for (var hd in dsHoaDon) {
      hd.xuatThongTin();
    }
  }

  void tongThanhTien() {
    double tong = dsHoaDon.fold(0, (sum, hd) => sum + hd.tinhThanhTien());
    print('Tong thanh tien: $tong');
  }

  void tongTroGia() {
    double tong = dsHoaDon.fold(0, (sum, hd) => sum + hd.tinhTroGia());
    print('Tong tien tro gia: $tong');
  }

  void khachHangMuaNhieuNhat() {
    if (dsHoaDon.isEmpty) return;
    int maxSL = dsHoaDon.fold(0, (max, hd) => hd.soLuong > max ? hd.soLuong : max);
    print('KH mua nhieu nhat ($maxSL):');
    dsHoaDon.where((hd) => hd.soLuong == maxSL).forEach((hd) => hd.xuatThongTin());
  }

  void tongChietKhauCongTy() {
    double tong = 0;
    for (var hd in dsHoaDon) {
      if (hd is KhachHangCongTy) {
        tong += hd.tinhChietKhau();
      }
    }
    print('Tong chiet khau KH Cong Ty: $tong');
  }

  void sapXep() {
    dsHoaDon.sort((a, b) {
      int cmp = a.soLuong.compareTo(b.soLuong);
      if (cmp != 0) return cmp;
      return b.tinhThanhTien().compareTo(a.tinhThanhTien());
    });
    print('Da sap xep tang dan theo SL, giam dan theo thanh tien.');
    xuatDanhSach();
  }

  void timKiemTheoMa(String ma) {
    bool found = false;
    for (var hd in dsHoaDon) {
      if (hd.maKH == ma) {
        hd.xuatThongTin();
        found = true;
      }
    }
    if (!found) {
      print('Khach hang khong ton tai');
    }
  }
}

void main() {
  QuanLyHoaDon ql = QuanLyHoaDon();
  while (true) {
    print('\n== MENU ==');
    print('1. Nhap DS');
    print('2. Xuat DS');
    print('3. Tong thanh tien');
    print('4. Tong tro gia');
    print('5. KH mua nhieu nhat');
    print('6. Tong chiet khau Cty');
    print('7. Sap xep');
    print('8. Tim kiem');
    print('0. Thoat');
    stdout.write('Chon: ');
    String? c = stdin.readLineSync();
    switch (c) {
      case '1': ql.nhapDanhSach(); break;
      case '2': ql.xuatDanhSach(); break;
      case '3': ql.tongThanhTien(); break;
      case '4': ql.tongTroGia(); break;
      case '5': ql.khachHangMuaNhieuNhat(); break;
      case '6': ql.tongChietKhauCongTy(); break;
      case '7': ql.sapXep(); break;
      case '8': 
        stdout.write('Nhap ma can tim: ');
        ql.timKiemTheoMa(stdin.readLineSync() ?? '');
        break;
      case '0': exit(0);
    }
  }
}