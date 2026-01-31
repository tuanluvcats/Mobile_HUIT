import 'dart:io';
import 'dart:math';

/* 
Bài tập 1. Hãy viết chương trình cho phép tạo một danh sách các số nguyên ngẫu nhiên trong phạm vi từ 5 đến 100. Thực hiện các yêu cầu sau:
a. Hãy xuất các phần tử trong danh sách ra màn hình. 
b. Tính trung bình cộng các số lẻ có trong danh sách. Nếu danh sách không có số lẻ hãy thông báo: Danh sách không có số lẻ.
c. Hãy cho biết danh sách có là danh sách đối xứng hay không?
d. Hãy cho biết danh sách tạo ra có được sắp xếp tăng dần hay không?
e. Tìm phần tử lớn nhất có trong danh sách.
f. Tìm phần tử là số chẵn lớn nhất. Nếu danh sách không có số chẵn hãy thông báo danh sách h ông có số chẵn.
g. Hãy nhập một giá trị, tìm xem giá trị vừa nhập có trong danh sách hay không?
Nếu danh sách không có giá trị vừa nhập, hãy thông báo: Không tìm thấy. Nếu
tìm thấy, hãy xóa các phần tử có cùng giá trị với giá trị vừa nhập.

Bài tập 2. Hãy viết chương trình thực hiện các yêu cầu sau:
a. Nhập vào 1 chuỗi và xuất chuỗi đó ra màn hình
b. Cho biết chuỗi có bao nhiêu kí tự là nguyên âm?
c. Cho biết chuỗi có bao nhiêu từ?
d. Cho biết chuỗi có đối xứng hay không?
e. Đảo ngược từ trong chuỗi. Ví dụ: Bò ăn cỏ ➔ cỏ ăn Bò
*/

void main() {
  while (true) {
    print('\n--- MENU BÀI TẬP ---');
    print('1. Bài 1: Tạo danh sách ngẫu nhiên');
    print('2. Bài 2: Viết chương trình');
    print('0. Thoát');
    stdout.write('Lựa chọn bài: ');

    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        baiTap1();
        break;
      case '2':
        baiTap2();
        break;
      case '0':
        exit(0);
      default:
        print('Lựa chọn không hợp lệ');
    }
  }
}

void baiTap1() {
  stdout.write('Nhập số lượng: ');
  int n = int.tryParse(stdin.readLineSync() ?? '') ?? 0;

  if (n <= 0) {
    print('Số lượng phải lớn hơn 0.');
    return;
  }

  List<int> numbers = [];
  Random rng = Random();

  for (int i = 0; i < n; i++) {
    numbers.add(rng.nextInt(96) + 5);
  }

  print('a. Danh sách vừa tạo: $numbers');

  List<int> oddNumbers = numbers.where((num) => num % 2 != 0).toList();
  if (oddNumbers.isEmpty) {
    print('b. Không có số lẻ trong danh sách.');
  } else {
    double avg = oddNumbers.reduce((a, b) => a + b) / oddNumbers.length;
    print('b. Trung bình các số lẻ: ${avg.toStringAsFixed(2)}');
  }

  bool isSymmetric = true;
  for (int i = 0; i < numbers.length ~/ 2; i++) {
    if (numbers[i] != numbers[numbers.length - 1 - i]) {
      isSymmetric = false;
      break;
    }
  }
  print('c. Danh sách ${isSymmetric ? "là" : "không là"} danh sách đối xứng.');

  bool isSorted = true;
  for (int i = 0; i < numbers.length - 1; i++) {
    if (numbers[i] > numbers[i + 1]) {
      isSorted = false;
      break;
    }
  }
  print('d. Danh sách ${isSorted ? "được" : "không được"} sắp xếp tăng dần.');

  int maxVal = numbers.reduce(max);
  print('e. Phần tử max: $maxVal');

  List<int> evenNumbers = numbers.where((num) => num % 2 == 0).toList();
  if (evenNumbers.isEmpty) {
    print('f. Danh sách không có số chẵn.');
  } else {
    int maxEven = evenNumbers.reduce(max);
    print('f. Số chẵn max là: $maxEven');
  }

  stdout.write('g. Nhập giá trị cần tìm và xóa: ');
  int findVal = int.tryParse(stdin.readLineSync() ?? '') ?? -1;

  if (!numbers.contains(findVal)) {
    print('Không tìm thấy giá trị $findVal trong danh sách.');
  } else {
    numbers.removeWhere((item) => item == findVal);
    print('Đã xóa. Danh sách mới: $numbers');
  }
}

void baiTap2() {
  stdout.write('Nhập vào một chuỗi: ');
  String inputStr = stdin.readLineSync() ?? '';
  print('a. Chuỗi vừa nhập: "$inputStr"');

  if (inputStr.trim().isEmpty) {
    print('Chuỗi rỗng');
    return;
  }

  String vowels = "uUeEoOaAiI";
  int vowelCount = 0;
  for (int i = 0; i < inputStr.length; i++) {
    if (vowels.contains(inputStr[i])) {
      vowelCount++;
    }
  }
  print('b. Số lượng kí tự nguyên âm: $vowelCount');

  List<String> words = inputStr.trim().split(RegExp(r'\s+'));
  print('c. Chuỗi có ${words.length} từ.');

  String reversedStr = inputStr.split('').reversed.join('');
  bool isPalindrome = inputStr.toLowerCase() == reversedStr.toLowerCase();
  print('d. Chuỗi ${isPalindrome ? "đối xứng" : "không đối xứng."}');

  String reversedWords = words.reversed.join(' ');
  print('e. Chuỗi đảo ngược: "$reversedWords"');
}
