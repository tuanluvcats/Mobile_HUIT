import 'package:flutter/material.dart';

class TTSinhVien extends StatelessWidget {
  const TTSinhVien({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thông tin sinh viên"),
        backgroundColor: Colors.blue[800],
        leading: const Icon(Icons.home),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 80,
                // Thay đổi từ NetworkImage sang AssetImage để lấy ảnh từ thư mục
                backgroundImage: AssetImage('Images/Avatar.jpg'),
              ),
              const SizedBox(height: 20),

              buildInfoRow("Họ và tên:", "Phạm Anh Tuấn", isName: true),
              buildInfoRow("MSSV:", "2001230855"),
              buildInfoRow("Lớp:", "14DHTH11"),
              buildInfoRow("Khóa:", "14"),
              buildInfoRow("Ngành:", "Công nghệ thông tin"),
              buildInfoRow(
                "Trường:",
                "Đại học Công Thương\nThành phố Hồ Chí Minh",
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.black,
                ),
                child: const Text("Trở về"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfoRow(String label, String value, {bool isName = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label ",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isName ? Colors.blue[800] : const Color(0xFFC62828),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: isName ? FontWeight.bold : FontWeight.normal,
                color: isName ? Colors.blue[800] : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
