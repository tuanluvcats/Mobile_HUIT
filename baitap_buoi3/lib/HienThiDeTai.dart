import 'package:flutter/material.dart';

class HienThiDeTai extends StatelessWidget {
  const HienThiDeTai({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Thanh tiêu đề
      appBar: AppBar(
        leading: const Icon(Icons.home),
        title: const Text("Thong tin de tai"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      // Thân chương trình
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Căn lề trái
          children: [
            const SizedBox(height: 20),
            // Mã đề tài
            const Text('Ma de tai: 01', style: TextStyle(fontSize: 22)),

            // Tên đề tài
            const Text(
              'De tai: He thong quan ly tai chinh ca nhan',
              style: TextStyle(fontSize: 22),
            ),

            // Số lượng sinh viên tối đa
            const Text(
              'So luong sinh viên toi da: 4 nguoi',
              style: TextStyle(fontSize: 22),
            ),

            // Chuyên ngành
            const Text(
              'Chuyen nganh: Cong nghe thong tin',
              style: TextStyle(fontSize: 22),
            ),

            // Giảng viên hướng dẫn
            const Text(
              'Giang vien huong dan: Nguyen Van A',
              style: TextStyle(fontSize: 22),
            ),

            // Yêu cầu đề tài
            const Text(
              'Yeu cau de tai: Tao he thong quan ly tai chinh ca nhan',
              style: TextStyle(fontSize: 22),
            ),
          ],
        ),
      ),
    );
  }
}
