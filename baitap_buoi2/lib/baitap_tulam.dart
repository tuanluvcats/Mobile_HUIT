import 'dart:io';
import 'dart:math';

void main() async {
  while (true) {
    print('\n==========================================');
    print('1. Bài tập 1: Quản lý Phòng Trọ');
    print('2. Bài tập 2: Quản lý Môn Học');
    print('0. Thoát chương trình');
    print('==========================================');
    stdout.write('Chọn bài: ');

    String? chon = stdin.readLineSync();

    switch (chon) {
      case '1':
        await runBaiTap1();
        break;
      case '2':
        await runBaiTap2();
        break;
      case '0':
        exit(0);
      default:
        print('Lựa chọn không hợp lệ');
    }
  }
}

class PhongTro {
  String _maPhong;
  int _soNguoi;
  int _soDien;
  int _soNuoc;

  PhongTro(this._maPhong, this._soNguoi, this._soDien, this._soNuoc);

  String get maPhong => _maPhong;
  set maPhong(String value) => _maPhong = value;

  int get soNguoi => _soNguoi;
  set soNguoi(int value) => _soNguoi = value;

  int get soDien => _soDien;
  set soDien(int value) => _soDien = value;

  int get soNuoc => _soNuoc;
  set soNuoc(int value) => _soNuoc = value;

  double tinhTienPhong() {
    return 0;
  }

  @override
  String toString() {
    return 'Mã: $_maPhong | Người: $_soNguoi | Điện: $_soDien | Nước: $_soNuoc';
  }
}

class PhongLoaiA extends PhongTro {
  int _soNguoiThan;

  PhongLoaiA(String maPhong, int soNguoi, int soDien, int soNuoc, this._soNguoiThan)
      : super(maPhong, soNguoi, soDien, soNuoc);

  @override
  double tinhTienPhong() {
    return 1400 + (2 * _soDien) + (8 * _soNuoc) + (50 * _soNguoiThan).toDouble();
  }

  @override
  String toString() {
    return '${super.toString()} | Người thân: $_soNguoiThan | Loại: A | Tiền: ${tinhTienPhong()}';
  }
}

class PhongLoaiB extends PhongTro {
  double _giatUi;
  int _soMay;

  PhongLoaiB(String maPhong, int soNguoi, int soDien, int soNuoc, this._giatUi, this._soMay)
      : super(maPhong, soNguoi, soDien, soNuoc);

  @override
  double tinhTienPhong() {
    return 2000 + (2 * _soDien) + (8 * _soNuoc) + (_giatUi * 5) + (_soMay * 100);
  }

  @override
  String toString() {
    return '${super.toString()} | Giặt ủi: $_giatUi kg | Máy: $_soMay | Loại: B | Tiền: ${tinhTienPhong()}';
  }
}

Future<void> runBaiTap1() async {
  List<PhongTro> danhSachPhong = [];
  await Bai1_taoFileMau();

  while (true) {
    print('\n== Bài 1 ==');
    print('1. Đọc dữ liệu từ file phongthue.txt');
    print('2. In danh sách phòng thuê');
    print('3. In danh sách phòng có > 2 người thuê');
    print('4. Tính tổng tiền phòng thu được');
    print('5. Sắp xếp danh sách giảm dần theo số điện');
    print('6. In danh sách các phòng loại A');
    print('0. Quay lại Menu chính');
    stdout.write('Chọn chức năng: ');

    String? chon = stdin.readLineSync();

    switch (chon) {
      case '1':
        await Bai1_docFile(danhSachPhong);
        break;
      case '2':
        Bai1_xuatDanhSach(danhSachPhong);
        break;
      case '3':
        Bai1_locPhongDongNguoi(danhSachPhong);
        break;
      case '4':
        Bai1_tinhTongTien(danhSachPhong);
        break;
      case '5':
        Bai1_sapXepTheoDien(danhSachPhong);
        break;
      case '6':
        Bai1_xuatPhongLoaiA(danhSachPhong);
        break;
      case '0':
        return;
      default:
        print('Lựa chọn không hợp lệ');
    }
  }
}

Future<void> Bai1_taoFileMau() async {
  final file = File('phongthue.txt');
  if (!await file.exists()) {
    String content = '''
A001#4#30#10#2
A002#6#45#20#4
B001#4#50#20#32#4
B002#2#30#40#20#2
''';
    await file.writeAsString(content);
    print('File phongthue.txt đã được tạo');
  }
}

Future<void> Bai1_docFile(List<PhongTro> list) async {
  try {
    final file = File('phongthue.txt');
    if (!await file.exists()) {
      print('File phongthue.txt không tồn tại');
      return;
    }

    List<String> lines = await file.readAsLines();
    list.clear();

    for (String line in lines) {
      if (line.trim().isEmpty) continue;
      List<String> parts = line.split('#');
      
      String maPhong = parts[0].trim();
      int soNguoi = int.parse(parts[1]);
      int soDien = int.parse(parts[2]);
      int soNuoc = int.parse(parts[3]);

      if (maPhong.startsWith('A')) {
        int nguoiThan = int.parse(parts[4]);
        list.add(PhongLoaiA(maPhong, soNguoi, soDien, soNuoc, nguoiThan));
      } else if (maPhong.startsWith('B')) {
        double giatUi = double.parse(parts[4]);
        int soMay = int.parse(parts[5]);
        list.add(PhongLoaiB(maPhong, soNguoi, soDien, soNuoc, giatUi, soMay));
      }
    }
    print('Đọc dữ liệu thành công');
    Bai1_xuatDanhSach(list);
  } catch (e) {
    print('Lỗi khi đọc file: $e');
  }
}

void Bai1_xuatDanhSach(List<PhongTro> list) {
  if (list.isEmpty) {
    print('Danh sách trống');
    return;
  }
  print('\nDANH SÁCH PHÒNG:');
  for (var p in list) {
    print(p);
  }
}

void Bai1_locPhongDongNguoi(List<PhongTro> list) {
  var kq = list.where((p) => p.soNguoi > 2).toList();
  if (kq.isEmpty) {
    print('Không có phòng nào > 2 người');
  } else {
    print('\nCÁC PHÒNG CÓ > 2 NGƯỜI: ');
    kq.forEach(print);
  }
}

void Bai1_tinhTongTien(List<PhongTro> list) {
  double tong = list.fold(0, (sum, p) => sum + p.tinhTienPhong());
  print('Tổng tiền phòng thu được: $tong');
}

void Bai1_sapXepTheoDien(List<PhongTro> list) {
  list.sort((a, b) => b.soDien.compareTo(a.soDien));
  print('Đã sắp xếp giảm dần theo số điện.');
  Bai1_xuatDanhSach(list);
}

void Bai1_xuatPhongLoaiA(List<PhongTro> list) {
  var kq = list.whereType<PhongLoaiA>().toList();
  if (kq.isEmpty) {
    print('Không có phòng loại A nào.');
  } else {
    print('\nDANH SÁCH PHÒNG LOẠI A: ');
    kq.forEach(print);
  }
}

abstract class MonHoc {
  String _maMH;
  String _tenMH;
  int _soTC;

  MonHoc(this._maMH, this._tenMH, this._soTC);

  String get maMH => _maMH;
  set maMH(String value) => _maMH = value;

  String get tenMH => _tenMH;
  set tenMH(String value) => _tenMH = value;

  int get soTC => _soTC;
  set soTC(int value) => _soTC = value;

  double tinhDTB();

  @override
  String toString() {
    return 'Mã: $_maMH | Tên: $_tenMH | TC: $_soTC | ĐTB: ${tinhDTB().toStringAsFixed(2)}';
  }
}

class LyThuyet extends MonHoc {
  double _diemTL;
  double _diemCK;

  LyThuyet(String maMH, String tenMH, int soTC, this._diemTL, this._diemCK)
      : super(maMH, tenMH, soTC);

  @override
  double tinhDTB() {
    return (_diemTL * 0.3) + (_diemCK * 0.7);
  }

  @override
  String toString() => '${super.toString()} (Lý thuyết)';
}

class ThucHanh extends MonHoc {
  double _d1, _d2, _d3;

  ThucHanh(String maMH, String tenMH, int soTC, this._d1, this._d2, this._d3)
      : super(maMH, tenMH, soTC);

  @override
  double tinhDTB() {
    return (_d1 + _d2 + _d3) / 3;
  }

  @override
  String toString() => '${super.toString()} (Thực hành)';
}

class DoAn extends MonHoc {
  double _dGVHD;
  double _dGVPB;

  DoAn(String maMH, String tenMH, int soTC, this._dGVHD, this._dGVPB)
      : super(maMH, tenMH, soTC);

  @override
  double tinhDTB() {
    return (_dGVHD + _dGVPB) / 2;
  }

  @override
  String toString() => '${super.toString()} (Đồ án)';
}

Future<void> runBaiTap2() async {
  List<MonHoc> danhSachMonHoc = [];
  await Bai2_taoFileMau();

  while (true) {
    print('\n== Bài 2 ==');
    print('1. Nhập danh sách môn học từ bàn phím');
    print('2. Xuất danh sách môn học');
    print('3. Kiểm tra danh sách có sắp xếp theo tên không');
    print('4. Sắp xếp danh sách theo số tín chỉ');
    print('5. Môn học có số tín chỉ cao nhất');
    print('6. Tìm kiếm môn học theo tên');
    print('7. Đọc danh sách từ file monhoc.txt');
    print('8. Tính số tín chỉ trung bình của danh sách');
    print('0. Quay lại Menu chính');
    stdout.write('Chọn chức năng: ');

    String? chon = stdin.readLineSync();

    switch (chon) {
      case '1':
        Bai2_nhapDanhSach(danhSachMonHoc);
        break;
      case '2':
        Bai2_xuatDanhSach(danhSachMonHoc);
        break;
      case '3':
        Bai2_kiemTraSapXepTen(danhSachMonHoc);
        break;
      case '4':
        Bai2_sapXepTheoTinChi(danhSachMonHoc);
        break;
      case '5':
        Bai2_timMonTinChiCaoNhat(danhSachMonHoc);
        break;
      case '6':
        Bai2_timKiemHoacThem(danhSachMonHoc);
        break;
      case '7':
        await Bai2_docFile(danhSachMonHoc);
        break;
      case '8':
        Bai2_tinhTinChiTrungBinh(danhSachMonHoc);
        break;
      case '0':
        return;
      default:
        print('Lựa chọn không hợp lệ');
    }
  }
}

void Bai2_nhapDanhSach(List<MonHoc> list) {
  stdout.write('Nhập số lượng môn học cần thêm: ');
  int? n = int.tryParse(stdin.readLineSync() ?? '');
  if (n == null || n <= 0) return;

  for (int i = 0; i < n; i++) {
    print('Nhập môn thứ ${i + 1}:');
    stdout.write('Loại (1-Lý thuyết, 2-Thực hành, 3-Đồ án): ');
    String? loai = stdin.readLineSync();

    stdout.write('Mã môn: ');
    String ma = stdin.readLineSync() ?? '';
    stdout.write('Tên môn: ');
    String ten = stdin.readLineSync() ?? '';
    stdout.write('Số tín chỉ: ');
    int tc = int.tryParse(stdin.readLineSync() ?? '0') ?? 0;

    if (loai == '1') {
      stdout.write('Điểm tiểu luận: ');
      double tl = double.tryParse(stdin.readLineSync() ?? '0') ?? 0;
      stdout.write('Điểm cuối kỳ: ');
      double ck = double.tryParse(stdin.readLineSync() ?? '0') ?? 0;
      list.add(LyThuyet(ma, ten, tc, tl, ck));
    } else if (loai == '2') {
      stdout.write('Điểm kiểm tra 1: ');
      double d1 = double.tryParse(stdin.readLineSync() ?? '0') ?? 0;
      stdout.write('Điểm kiểm tra 2: ');
      double d2 = double.tryParse(stdin.readLineSync() ?? '0') ?? 0;
      stdout.write('Điểm kiểm tra 3: ');
      double d3 = double.tryParse(stdin.readLineSync() ?? '0') ?? 0;
      list.add(ThucHanh(ma, ten, tc, d1, d2, d3));
    } else if (loai == '3') {
      stdout.write('Điểm GVHD: ');
      double gvhd = double.tryParse(stdin.readLineSync() ?? '0') ?? 0;
      stdout.write('Điểm GVPB: ');
      double gvpb = double.tryParse(stdin.readLineSync() ?? '0') ?? 0;
      list.add(DoAn(ma, ten, tc, gvhd, gvpb));
    } else {
      print('Loại không hợp lệ');
    }
  }
}

void Bai2_xuatDanhSach(List<MonHoc> list) {
  if (list.isEmpty) {
    print('Danh sách trống.');
    return;
  }
  print('\nDANH SÁCH MÔN HỌC: ');
  for (var mh in list) {
    print(mh);
  }
}

void Bai2_kiemTraSapXepTen(List<MonHoc> list) {
  if (list.length < 2) {
    print('Danh sách đã được sắp xếp.');
    return;
  }
  bool isSorted = true;
  for (int i = 0; i < list.length - 1; i++) {
    if (list[i].tenMH.compareTo(list[i + 1].tenMH) > 0) {
      isSorted = false;
      break;
    }
  }
  if (isSorted) {
    print('Danh sách được sắp xếp tăng dần theo tên.');
  } else {
    print('Danh sách chưa được sắp xếp theo tên.');
  }
}

void Bai2_sapXepTheoTinChi(List<MonHoc> list) {
  list.sort((a, b) => a.soTC.compareTo(b.soTC));
  print('Danh sách đã được sắp xếp theo số tín chỉ.');
  Bai2_xuatDanhSach(list);
}

void Bai2_timMonTinChiCaoNhat(List<MonHoc> list) {
  if (list.isEmpty) return;
  int maxTC = list.map((e) => e.soTC).reduce(max);
  print('Các môn học có số tín chỉ cao nhất ($maxTC):');
  list.where((e) => e.soTC == maxTC).forEach((e) => print(e));
}

void Bai2_timKiemHoacThem(List<MonHoc> list) {
  stdout.write('Nhập tên môn học cần tìm: ');
  String tenCanTim = stdin.readLineSync() ?? '';
  
  var ketQua = list.where((mh) => mh.tenMH.toLowerCase() == tenCanTim.toLowerCase()).toList();

  if (ketQua.isNotEmpty) {
    print('Tìm thấy môn học:');
    ketQua.forEach((e) => print(e));
  } else {
    print('Không tìm thấy môn "$tenCanTim". Đang thêm vào cuối');
    stdout.write('Nhập mã cho môn mới: ');
    String ma = stdin.readLineSync() ?? 'NEW001';
    stdout.write('Nhập số tín chỉ: ');
    int tc = int.tryParse(stdin.readLineSync() ?? '0') ?? 0;
    list.add(LyThuyet(ma, tenCanTim, tc, 0, 0));
    print('Đã thêm thành công.');
  }
}

Future<void> Bai2_taoFileMau() async {
  final file = File('monhoc.txt');
  if (!await file.exists()) {
    String content = '''
LT#MH001#Lap Trinh Dart#3#8.5#9.0
TH#MH002#Lap Trinh Web#4#7.0#8.0#7.5
DA#MH003#Do An Tot Nghiep#10#9.0#8.5
LT#MH004#Co So Du Lieu#3#6.5#7.0
TH#MH005#Mang May Tinh#3#8.0#8.0#8.0
''';
    await file.writeAsString(content);
    print('File monhoc.txt đã tạo');
  }
}

Future<void> Bai2_docFile(List<MonHoc> list) async {
  try {
    final file = File('monhoc.txt');
    if (!await file.exists()) {
      print('Không tồn tại file monhoc.txt');
      return;
    }

    List<String> lines = await file.readAsLines();
    list.clear();
    
    for (String line in lines) {
      if (line.trim().isEmpty) continue;
      List<String> parts = line.split('#');
      
      String loai = parts[0];
      String ma = parts[1];
      String ten = parts[2];
      int tc = int.parse(parts[3]);

      if (loai == 'LT') {
        list.add(LyThuyet(ma, ten, tc, double.parse(parts[4]), double.parse(parts[5])));
      } else if (loai == 'TH') {
        list.add(ThucHanh(ma, ten, tc, double.parse(parts[4]), double.parse(parts[5]), double.parse(parts[6])));
      } else if (loai == 'DA') {
        list.add(DoAn(ma, ten, tc, double.parse(parts[4]), double.parse(parts[5])));
      }
    }
    print('Đọc dữ liệu từ file thành công');
    Bai2_xuatDanhSach(list);
  } catch (e) {
    print('Lỗi khi đọc file: $e');
  }
}

void Bai2_tinhTinChiTrungBinh(List<MonHoc> list) {
  if (list.isEmpty) {
    print('Không có môn học nào trong danh sách');
    return;
  }
  double tongTC = list.fold(0, (sum, item) => sum + item.soTC);
  double tb = tongTC / list.length;
  print('Tổng số môn: ${list.length}');
  print('Tổng số tín chỉ: $tongTC');
  print('Số tín chỉ trung bình: ${tb.toStringAsFixed(2)}');
}