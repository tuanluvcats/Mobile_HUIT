import 'dart:io';
import 'dart:math';

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

void main() async {
  List<MonHoc> danhSachMonHoc = [];

  await taoFileMau();

  while (true) {
    print('\n== QUẢN LÝ MÔN HỌC ==');
    print('1. Nhập danh sách môn học từ bàn phím');
    print('2. Xuất danh sách môn học');
    print('3. Kiểm tra danh sách có sắp xếp theo tên không');
    print('4. Sắp xếp danh sách theo số tín chỉ (tăng dần)');
    print('5. Môn học có số tín chỉ cao nhất');
    print('6. Tìm kiếm môn học theo tên');
    print('7. Đọc danh sách từ file monhoc.txt');
    print('8. Tính số tín chỉ trung bình của danh sách');
    print('0. Thoát');
    stdout.write('Chọn chức năng: ');

    String? chon = stdin.readLineSync();

    switch (chon) {
      case '1':
        nhapDanhSach(danhSachMonHoc);
        break;
      case '2':
        xuatDanhSach(danhSachMonHoc);
        break;
      case '3':
        kiemTraSapXepTen(danhSachMonHoc);
        break;
      case '4':
        sapXepTheoTinChi(danhSachMonHoc);
        break;
      case '5':
        timMonTinChiCaoNhat(danhSachMonHoc);
        break;
      case '6':
        timKiemHoacThem(danhSachMonHoc);
        break;
      case '7':
        await docFile(danhSachMonHoc);
        break;
      case '8':
        tinhTinChiTrungBinh(danhSachMonHoc);
        break;
      case '0':
        exit(0);
      default:
        print('Lựa chọn không hợp lệ!');
    }
  }
}

void nhapDanhSach(List<MonHoc> list) {
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
      print('Loại không hợp lệ, bỏ qua.');
    }
  }
}

void xuatDanhSach(List<MonHoc> list) {
  if (list.isEmpty) {
    print('Danh sách trống.');
    return;
  }
  print('\nDANH SÁCH MÔN HỌC: ');
  for (var mh in list) {
    print(mh);
  }
}

void kiemTraSapXepTen(List<MonHoc> list) {
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

void sapXepTheoTinChi(List<MonHoc> list) {
  list.sort((a, b) => a.soTC.compareTo(b.soTC));
  print('Danh sách tăng dần theo số tín chỉ: ');
  xuatDanhSach(list);
}

void timMonTinChiCaoNhat(List<MonHoc> list) {
  if (list.isEmpty) return;
  int maxTC = list.map((e) => e.soTC).reduce(max);
  print('Các môn học có số tín chỉ cao nhất ($maxTC):');
  list.where((e) => e.soTC == maxTC).forEach((e) => print(e));
}

void timKiemHoacThem(List<MonHoc> list) {
  stdout.write('Nhập tên môn học cần tìm: ');
  String tenCanTim = stdin.readLineSync() ?? '';

  var ketQua = list
      .where((mh) => mh.tenMH.toLowerCase() == tenCanTim.toLowerCase())
      .toList();

  if (ketQua.isNotEmpty) {
    print('Tìm thấy môn học:');
    ketQua.forEach((e) => print(e));
  } else {
    print('Không tìm thấy môn "$tenCanTim". Thêm vào danh sách.');
    stdout.write('Nhập mã cho môn mới: ');
    String ma = stdin.readLineSync() ?? 'NEW001';
    stdout.write('Nhập số tín chỉ: ');
    int tc = int.tryParse(stdin.readLineSync() ?? '0') ?? 0;
    list.add(LyThuyet(ma, tenCanTim, tc, 0, 0));
    print('Đã thêm thành công.');
  }
}

Future<void> taoFileMau() async {
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
    print('Đã tạo file mẫu monhoc.txt');
  }
}

Future<void> docFile(List<MonHoc> list) async {
  try {
    final file = File('monhoc.txt');
    if (!await file.exists()) {
      print('Không có file monhoc.txt.');
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
        list.add(
          LyThuyet(ma, ten, tc, double.parse(parts[4]), double.parse(parts[5])),
        );
      } else if (loai == 'TH') {
        list.add(
          ThucHanh(
            ma,
            ten,
            tc,
            double.parse(parts[4]),
            double.parse(parts[5]),
            double.parse(parts[6]),
          ),
        );
      } else if (loai == 'DA') {
        list.add(
          DoAn(ma, ten, tc, double.parse(parts[4]), double.parse(parts[5])),
        );
      }
    }
    print('Đọc dữ liệu từ file thành công.');
    xuatDanhSach(list);
  } catch (e) {
    print('Lỗi khi đọc file: $e');
  }
}

void tinhTinChiTrungBinh(List<MonHoc> list) {
  if (list.isEmpty) {
    print('Danh sách trống.');
    return;
  }
  double tongTC = list.fold(0, (sum, item) => sum + item.soTC);
  double tb = tongTC / list.length;
  print('Tổng số môn: ${list.length}');
  print('Tổng số tín chỉ: $tongTC');
  print('Số tín chỉ trung bình: ${tb.toStringAsFixed(2)}');
}
