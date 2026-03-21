import 'package:flutter/material.dart';

class Layoutqua extends StatefulWidget {
  const Layoutqua({super.key});

  @override
  State<Layoutqua> createState() => _LayoutquaState();
}

class _LayoutquaState extends State<Layoutqua> {
  List<bool> favoriteStates = [false, true, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 252, 220, 233),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Quà của Tuấn (7)",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.support_agent, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCatagory("", icon: Icons.filter_alt_outlined),
                _buildCatagory("Sắp xếp", icon: Icons.sort),
                _buildCatagory("Dịch vụ", icon: Icons.keyboard_arrow_down),
                _buildCatagory("Gần tôi"),
                _buildCatagory("Yêu thích"),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [_buildBannerXu(), _buildBannerQua()],
            ),
          ),

          _buildGiftCard(
            index: 0,
            icon: Icons.movie,
            iconColor: Colors.red,
            brand: "CGV",
            title: "Giảm 79K",
            subtitle: "Đồng giá 79K khi mua vé CGV 2D trên M...",
            date: "HSD: 28/02/2025",
            buttonText: "Dùng ngay",
            isThuThap: false,
          ),
          _buildGiftCard(
            index: 1,
            icon: Icons.sim_card,
            iconColor: Colors.pink,
            brand: "Mua Sim\nchính chủ",
            title: "Giảm 100K",
            subtitle: "Cho đơn từ 0đ",
            date: "HSD: 28/02/2025",
            buttonText: "Dùng ngay",
            isThuThap: false,
          ),
          _buildGiftCard(
            index: 2,
            icon: Icons.account_balance,
            iconColor: Colors.orange,
            brand: "Ngân hàng\nQuốc Tế VIB",
            title: "Tặng 100K",
            subtitle: "Khi mở thẻ VIB Online Plus 2in1 (*)",
            date: "HSD: 31/03/2025",
            buttonText: "Dùng ngay",
            isThuThap: false,
            hasTag: true,
          ),
          _buildGiftCard(
            index: 3,
            icon: Icons.umbrella,
            iconColor: Colors.blue,
            brand: "Thanh toán\nBảo hiểm",
            title: "Hoàn 15K",
            subtitle: "Cho hóa đơn từ 3.000.000đ",
            date: "Hết hạn sau 5 ngày",
            dateColor: Colors.orange,
            buttonText: "Dùng ngay",
            isThuThap: false,
          ),
          _buildGiftCard(
            index: 4,
            icon: Icons.car_rental,
            iconColor: Colors.orange,
            brand: "Phí không\ndừng",
            title: "Giảm 10K",
            subtitle: "Cho đơn từ 100K",
            date: "",
            buttonText: "Thu thập",
            isThuThap: true,
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildCatagory(String text, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Row(
        children: [
          if (text.isEmpty && icon != null)
            Icon(icon, size: 18, color: Colors.black54),
          if (text.isNotEmpty)
            Text(
              text,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
          if (text.isNotEmpty && icon != null) ...[
            const SizedBox(width: 4),
            Icon(icon, size: 16, color: Colors.black54),
          ],
        ],
      ),
    );
  }

  Widget _buildBannerXu() {
    return Container(
      width: 175,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 248, 235),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.monetization_on,
              color: Colors.white,
              size: 20,
            ),
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Đang có",
                style: TextStyle(fontSize: 10, color: Colors.black54),
              ),
              Text(
                "1.955 Xu",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Icon(Icons.chevron_right, size: 20, color: Colors.orange),
        ],
      ),
    );
  }

  Widget _buildBannerQua() {
    return Container(
      width: 175,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.card_giftcard, color: Colors.red, size: 28),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Bỏ túi ngay",
                style: TextStyle(fontSize: 10, color: Colors.white70),
              ),
              Text(
                "4 thẻ quà",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.chevron_right,
              size: 18,
              color: Colors.blueAccent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGiftCard({
    required int index,
    required IconData icon,
    required Color iconColor,
    required String brand,
    required String title,
    required String subtitle,
    required String date,
    required String buttonText,
    required bool isThuThap,
    Color dateColor = Colors.grey,
    bool hasTag = false,
  }) {
    bool isFavorite = favoriteStates[index];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: const [
          BoxShadow(color: Colors.black12, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            alignment: Alignment.center,
            child: Column(
              children: [
                Icon(icon, color: iconColor, size: 30),
                const SizedBox(height: 5),
                Text(
                  brand,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 180,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                if (date.isNotEmpty)
                  Text(date, style: TextStyle(fontSize: 11, color: dateColor)),
                if (hasTag) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      "Quà hiện vật",
                      style: TextStyle(fontSize: 10, color: Colors.black54),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Container(
            width: 80,
            height: 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      favoriteStates[index] = !favoriteStates[index];
                    });
                  },
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.pink : Colors.grey,
                    size: 20,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isThuThap ? Colors.pink : Colors.transparent,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    buttonText,
                    style: TextStyle(
                      color: Colors.pink,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
