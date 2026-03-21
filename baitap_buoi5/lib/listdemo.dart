import 'package:flutter/material.dart';

class Listdemo extends StatelessWidget {
  const Listdemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 239, 168, 4),
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "ListView Demo",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            color: Colors.blue,
            child: const Text(
              "Chọn loại đề tài",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCircleItem("Đồ án"),
                _buildCircleItem("KLKS"),
                _buildCircleItem("Luận văn"),
                _buildCircleItem("Khác"),
              ],
            ),
          ),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            color: Colors.blue,
            child: const Text(
              "Chọn chuyên ngành thực hiện",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          _buildListItem(
            title: "Công nghệ phần mềm",
            subtitle: "Phát triển các ứng dụng giải quyết các vấn đề thực tế",
          ),
          _buildListItem(
            title: "Hệ thống thông tin",
            subtitle: "Phát triển các kỹ thuật xử lý thông tin trong tổ chức",
          ),
          _buildListItem(
            title: "Mạng máy tính",
            subtitle: "Xử lý các vấn đề liên quan đến mạng máy tính",
          ),
          _buildListItem(
            title: "An toàn thông tin",
            subtitle: "Thiết kế và đảm bảo an toàn cho hệ thống máy tính",
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildCircleItem(String text) {
    return Container(
      width: 90,
      height: 90,
      decoration: const BoxDecoration(
        color: Colors.deepPurple,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildListItem({required String title, required String subtitle}) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        color: const Color.fromARGB(255, 200, 197, 177),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: const Icon(Icons.home, color: Colors.black54),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.red,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
        trailing: const Icon(Icons.arrow_forward, color: Colors.black54),
        onTap: () {},
      ),
    );
  }
}
