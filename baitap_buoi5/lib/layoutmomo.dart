import 'package:flutter/material.dart';

class LayoutMoMo extends StatelessWidget {
  const LayoutMoMo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.pink,
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("MoMo", style: TextStyle(color: Colors.white)),
      ),
      body: ListView(
        children: <Widget>[
          Container(height: 15),
          GridView.count(
            shrinkWrap: true,
            physics:
                const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            children: <Widget>[
              _buildGridItem(Icons.payment, Colors.pink, 'Chuyển tiền'),
              _buildGridItem(Icons.receipt, Colors.teal, 'Thanh toán\nhóa đơn'),
              _buildGridItem(
                Icons.phone_android,
                Colors.blue,
                'Nạp tiền điện\nthoại',
              ),
              _buildGridItem(
                Icons.sd_card,
                Colors.lightBlue,
                'Mua mã thẻ di\nđộng',
              ),
              _buildGridItem(Icons.eco, Colors.pinkAccent, 'Hoa Đất MoMo'),
              _buildGridItem(
                Icons.directions_walk,
                Colors.green,
                'Đi bộ cùng\nMoMo',
              ),
              _buildGridItem(
                Icons.water_drop,
                Colors.blueAccent,
                'Thanh toán\nnước',
              ),
              _buildGridItem(
                Icons.account_balance_wallet,
                Colors.teal,
                'Quản lý chi\ntiêu',
              ),
              _buildGridItem(Icons.group, Colors.purple, 'Quỹ nhóm'),
              _buildGridItem(Icons.show_chart, Colors.blue, 'Chứng Khoán'),
              _buildGridItem(Icons.sms, Colors.redAccent, 'Vietlott SMS'),
              _buildGridItem(Icons.grid_view, Colors.grey, 'Xem thêm\ndịch vụ'),
            ],
          ),

          const Divider(color: Colors.grey, height: 20, thickness: 1),

          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Sự kiện đang diễn ra',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          Container(
            margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            height: 100,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 230, 200),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.pink),
            ),
            alignment: Alignment.center,
            child: const Text(
              'Tích Lộc cùng nhiều\nĐến 50 triệu',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'MoMo đề xuất',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            children: <Widget>[
              _buildGridItem(Icons.account_balance, Colors.orange, 'Vay Nhanh'),
              _buildGridItem(Icons.movie, Colors.purple, 'Mua vé xem phim'),
              _buildGridItem(Icons.wallet_giftcard, Colors.red, 'Túi Thần Tài'),
              _buildGridItem(Icons.payment, Colors.pink, 'Ví Trả Sau'),
            ],
          ),

          Container(
            margin: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 245, 200),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.yellow),
            ),
            child: ListTile(
              leading: const Icon(Icons.card_giftcard, color: Colors.red),
              title: const Text(
                '2025 nhờ ai mà nở hoa?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              subtitle: const Text('Gieo quẻ với AI, tìm quý nhân của bạn'),
              trailing: ElevatedButton(
                onPressed: () {},
                child: const Text('Gieo ngay'),
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Có thể bạn quan tâm',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          Container(height: 20),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'MoMo'),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer),
            label: 'Ưu đãi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner, color: Colors.pink),
            label: 'Quét mã QR',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Lịch sử'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Tôi'),
        ],
      ),
    );
  }

  Widget _buildGridItem(IconData icon, Color iconColor, String title) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(icon, color: iconColor, size: 30),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}
