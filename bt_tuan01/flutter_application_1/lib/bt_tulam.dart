import 'dart:io';
import 'dart:math';

void main() {
  while (true) {
    print('\n--- MENU BÀI TẬP ---');
    print('1. Bài tập 1: Tính tiền kem');
    print('2. Bài tập 2: Phân tích số nguyên');
    print('3. Bài tập 3: Xử lý danh sách');
    print('0. Thoát');
    stdout.write('Chọn bài tập (0-3): ');

    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        baiTap1();
        break;
      case '2':
        baiTap2();
        break;
      case '3':
        baiTap3();
        break;
      case '0':
        exit(0);
      default:
        print('Lựa chọn không hợp lệ!');
    }
  }
}

// --- BÀI TẬP 1: TÍNH TIỀN KEM ---
void baiTap1() {
  print('\n--- BÀI TẬP 1 ---');
  // Nhập số lượng
  stdout.write('Nhập số lượng kem cần mua (>0): ');
  int soLuong = int.tryParse(stdin.readLineSync() ?? '') ?? 0;

  // Nhập đơn giá
  stdout.write('Nhập giá 1 que kem: ');
  double donGia = double.tryParse(stdin.readLineSync() ?? '') ?? 0;

  if (soLuong <= 0 || donGia <= 0) {
    print('Số liệu nhập không hợp lệ!');
    return;
  }

  double tongTien = soLuong * donGia;
  double thanhTien = tongTien;

  if (soLuong > 10) {
    thanhTien = tongTien * 0.9; // Giảm 10%
    print('Được giảm 10%.');
  } else if (soLuong >= 5) {
    thanhTien = tongTien * 0.95; // Giảm 5%
    print('Được giảm 5%.');
  } else {
    print('Không được giảm giá.');
  }

  print('Tổng tiền phải trả: ${thanhTien.toStringAsFixed(0)} VNĐ');
}

// --- BÀI TẬP 2: PHÂN TÍCH SỐ NGUYÊN ---
void baiTap2() {
  print('\n--- BÀI TẬP 2 ---');
  stdout.write('Nhập số nguyên dương (>10): ');
  int n = int.tryParse(stdin.readLineSync() ?? '') ?? 0;

  if (n <= 10) {
    print('Vui lòng nhập số lớn hơn 10!');
    return;
  }

  // a. Số lượng chữ số
  String nStr = n.toString();
  print('a. Số này có ${nStr.length} chữ số.');

  // b. Tổng các chữ số
  int sum = 0;
  bool coSoLe = false;

  for (int i = 0; i < nStr.length; i++) {
    int digit = int.parse(nStr[i]);
    sum += digit;

    // c. Kiểm tra số lẻ
    if (digit % 2 != 0) {
      coSoLe = true;
    }
  }
  print('b. Tổng các chữ số là: $sum');
  print('c. Số này ${coSoLe ? "CÓ" : "KHÔNG"} chứa chữ số lẻ.');
}

// --- BÀI TẬP 3: DANH SÁCH ---
void baiTap3() {
  print('\n--- BÀI TẬP 3 ---');
  List<int> danhSach = [];

  // Nhập danh sách
  stdout.write('Nhập số lượng phần tử của danh sách: ');
  int n = int.tryParse(stdin.readLineSync() ?? '') ?? 0;

  for (int i = 0; i < n; i++) {
    stdout.write('Nhập phần tử thứ $i: ');
    int val = int.tryParse(stdin.readLineSync() ?? '') ?? 0;
    danhSach.add(val);
  }

  // a. Xuất danh sách
  print('a. Danh sách vừa nhập: $danhSach');

  // b. Tính tổng
  int tong = danhSach.fold(0, (sum, element) => sum + element);
  print('b. Tổng các phần tử: $tong');

  // c. Xuất số nguyên tố
  List<int> snt = danhSach.where((e) => kiemTraNguyenTo(e)).toList();
  print('c. Các số nguyên tố trong danh sách: $snt');

  // d. Tìm kiếm và thêm
  stdout.write('d. Nhập một giá trị k bất kỳ để kiểm tra: ');
  int k = int.tryParse(stdin.readLineSync() ?? '') ?? 0;

  if (danhSach.contains(k)) {
    print(
      'Giá trị $k có trong danh sách tại vị trí index: ${danhSach.indexOf(k)}',
    );
  } else {
    danhSach.insert(0, k); // Thêm vào đầu
    print('Giá trị $k không có. Đã thêm vào đầu danh sách.');
    print('Danh sách mới: $danhSach');
  }
}

// Hàm phụ trợ kiểm tra số nguyên tố
bool kiemTraNguyenTo(int n) {
  if (n < 2) return false;
  for (int i = 2; i <= sqrt(n); i++) {
    if (n % i == 0) return false;
  }
  return true;
}
