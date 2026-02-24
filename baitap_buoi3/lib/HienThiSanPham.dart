import 'package:flutter/material.dart';

class HienThiSanPham extends StatelessWidget {
  const HienThiSanPham({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.shopping_cart),
        title: const Text("Chi tiết sản phẩm"),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Khu vực hiển thị 3 hình ảnh (Cuộn ngang)
            SizedBox(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildProductImage('Images/1.webp'),
                  const SizedBox(width: 10),
                  _buildProductImage('Images/2.webp'),
                  const SizedBox(width: 10),
                  _buildProductImage('Images/3.webp'),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // 2. Tên sản phẩm
            const Text(
              'Laptop Gaming Acer Nitro 5 Tiger',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),

            // 3. Giá bán (Làm nổi bật bằng màu đỏ)
            const Text(
              '24.990.000 đ',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 20),

            // 4. Thông tin chi tiết (Mã SP, Nhà sản xuất)
            _buildInfoRow('Mã sản phẩm:', 'ACER-N5-2024'),
            _buildInfoRow('Nhà sản xuất:', 'Acer Taiwan'),

            const SizedBox(height: 25),

            // 5. Mô tả sản phẩm
            const Text(
              'Mô tả sản phẩm:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Laptop Acer Nitro 5 Tiger là dòng laptop gaming quốc dân được trang bị CPU Intel Core i7 thế hệ 12 mới nhất, card đồ họa RTX 3050Ti cùng hệ thống tản nhiệt độc quyền giúp máy luôn mát mẻ khi chiến các tựa game nặng.',
              style: TextStyle(fontSize: 16, height: 1.5),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }

  // Widget phụ trợ tạo khung ảnh
  Widget _buildProductImage(String path) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.asset(
          path,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey[200],
            child: const Icon(
              Icons.image_not_supported,
              size: 50,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  // Widget phụ trợ tạo dòng thông tin
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 17, color: Colors.blueGrey),
          ),
        ],
      ),
    );
  }
}
