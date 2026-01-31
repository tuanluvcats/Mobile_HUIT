import 'dart:io';
import 'dart:math';

/* 
Bài tập 1. Hãy viết chương trình cho phép nhập vào một số nguyên >0 là số que kem cần mua, nhập giá tiền cho một que kem. Tính tiền phải trả biết rằng nếu mua số lượng que kem lớn hơn 10 que thì tiền phải trả được giảm 10%; nếu số lượng que kem >=5 và <=10 thì tiền phải trả sẽ được giảm 5%; các trường hợp khác không giảm.

Bài tập 2. Hãy viết chương trình cho phép nhập vào một số nguyên dương > 10.
a. Cho biết số nguyên nhập vào là số có bao nhiêu chữ số?
b. Tính tổng các chữ số có trong số nguyên nhập vào.
c. Cho biết số nhập vào có chứa chữ số nào là số lẻ hay không?

Bài tập 3. Viết chương trình nhập vào một danh sách các số nguyên và thực hiện các yêu cầu:
a. Xuất danh sách vừa nhập ra màn hình
b. Tính tổng các phần tử có trong danh sách
c. Hãy xuất các phần tử là số nguyên tố có trong danh sách
d. Nhập vào một giá trị bất kỳ, cho biết giá trị đó có trong danh sách hay không? Nếu không có, hãy thêm giá trị đó vào đầu danh sách. Nếu có hãy cho biết giá trị đó ở vị trí nào trong danh sách. */

void main() {
  while (true) {
    print('\n--- MENU BÀI TẬP ---');
    print('1. Bài 1: Tính tiền kem');
    print('2. Bài 2: Phân tích số nguyên');
    print('3. Bài 3: Xử lý danh sách');
    print('0. Thoát');
    stdout.write('Lựa chọn bài: ');

    String? input = stdin.readLineSync();

    switch (input) {
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

void baiTap1() {
  stdout.write('Nhập số lượng kem cần mua: ');
  int soLuong = int.tryParse(stdin.readLineSync() ?? '') ?? 0;

  stdout.write('Nhập giá 1 que kem: ');
  double donGia = double.tryParse(stdin.readLineSync() ?? '') ?? 0;

  if (soLuong <= 0 || donGia <= 0) {
    print('Nhập lại số lượng hoặc đơn giá');
    return;
  }

  double tongTien = soLuong * donGia;
  double thanhTien = tongTien;

  if (soLuong > 10) {
    thanhTien = tongTien * 0.9;
  } else if (soLuong >= 5) {
    thanhTien = tongTien * 0.95;
  }

  print('Tổng tiền phải trả: ${thanhTien.toStringAsFixed(0)} VNĐ');
}

void baiTap2() {
  stdout.write('Nhập số nguyên dương (>10): ');
  int n = int.tryParse(stdin.readLineSync() ?? '') ?? 0;

  if (n <= 10) {
    print('Số phải lớn hơn 10');
    return;
  }

  String nStr = n.toString();
  print('a. Số này có ${nStr.length} chữ số.');

  int sum = 0;
  bool coSoLe = false;

  for (int i = 0; i < nStr.length; i++) {
    int digit = int.parse(nStr[i]);
    sum += digit;

    if (digit % 2 != 0) {
      coSoLe = true;
    }
  }
  print('b. Tổng các chữ số là: $sum');
  print('c. Số này ${coSoLe ? "có" : "không"} chứa chữ số lẻ.');
}

void baiTap3() {
  List<int> danhSach = [];

  stdout.write('Nhập n phần tử của danh sách: ');
  int n = int.tryParse(stdin.readLineSync() ?? '') ?? 0;

  for (int i = 0; i < n; i++) {
    stdout.write('Nhập phần tử thứ $i: ');
    int val = int.tryParse(stdin.readLineSync() ?? '') ?? 0;
    danhSach.add(val);
  }

  print('a. Danh sách: $danhSach');

  int tong = danhSach.fold(0, (sum, element) => sum + element);
  print('b. Tổng các phần tử: $tong');

  List<int> snt = danhSach.where((e) => kiemTraNguyenTo(e)).toList();
  print('c. Các số nguyên tố trong danh sách: $snt');

  stdout.write('d. Nhập một giá trị k bất kỳ để kiểm tra: ');
  int k = int.tryParse(stdin.readLineSync() ?? '') ?? 0;

  if (danhSach.contains(k)) {
    print(
      'Giá trị $k có trong danh sách tại vị trí index: ${danhSach.indexOf(k)}',
    );
  } else {
    danhSach.insert(0, k);
    print('Giá trị $k không có. Đã thêm vào đầu danh sách.');
    print('Danh sách mới: $danhSach');
  }
}

bool kiemTraNguyenTo(int n) {
  if (n < 2) return false;
  for (int i = 2; i <= sqrt(n); i++) {
    if (n % i == 0) return false;
  }
  return true;
}
