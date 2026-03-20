import 'package:flutter/material.dart';

class GioiThieuKhoaCNTT extends StatelessWidget {
  const GioiThieuKhoaCNTT({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Giới thiệu Khoa CNTT - HUIT"),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Logo khoa
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Image.asset(
                  'Images/Logo.png',
                  width: double.infinity,
                  height: 100,
                  fit: BoxFit.contain,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. Lời chào/Giới thiệu chung
                  const Text(
                    "Chào mừng bạn đến với Khoa CNTT trường Đại học Công thương TP.HCM. Khoa là nơi đào tạo nguồn nhân lực chất lượng cao trong lĩnh vực công nghệ và an ninh mạng.",
                    style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 20),

                  // 3. Ngành Công nghệ Thông tin
                  _buildMajorCard(
                    context,
                    "Ngành Công nghệ Thông tin",
                    Icons.computer,
                    Colors.blue,
                    "Đào tạo các kiến thức về phát triển phần mềm, trí tuệ nhân tạo, và quản trị hệ thống. Sinh viên được thực hành với các công nghệ mới nhất như Cloud Computing, Big Data.",
                  ),

                  const SizedBox(height: 16),

                  // 4. Ngành An toàn Thông tin
                  _buildMajorCard(
                    context,
                    "Ngành An toàn Thông tin",
                    Icons.security,
                    Colors.red,
                    "Tập trung vào bảo vệ hệ thống mạng, phòng chống tấn công mạng và mật mã học. Đây là ngành học then chốt trong kỷ nguyên số hiện nay.",
                  ),

                  const SizedBox(height: 25),

                  // 5. Thông tin liên hệ nhanh
                  const Divider(),
                  const ListTile(
                    leading: Icon(Icons.location_on, color: Colors.blue),
                    title: Text(
                      "Địa chỉ: 140 Lê Trọng Tấn, P. Tây Thạnh, Q. Tân Phú, TP. HCM",
                    ),
                  ),
                  const ListTile(
                    leading: Icon(Icons.web, color: Colors.blue),
                    title: Text("Website: https://its.huit.edu.vn/"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget tạo thẻ thông tin ngành học (sử dụng ExpansionTile)
  Widget _buildMajorCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    String description,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: Icon(icon, color: color, size: 30),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 18,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              description,
              style: const TextStyle(fontSize: 15, height: 1.4),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}
