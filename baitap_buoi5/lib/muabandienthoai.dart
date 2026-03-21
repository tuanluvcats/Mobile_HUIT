import 'package:flutter/material.dart';

List<Map<String, dynamic>> cartItems = [];

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue, width: 2),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Image.asset('assets/logo.png')],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Cửa hàng điện thoại",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "140 Lê Trọng Tân, Tân Phú, TP.Hồ Chí Minh",
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 40),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_forward, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProductScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final List<Map<String, dynamic>> products = [
    {
      "name": "Điện thoại 01",
      "desc": "Điện thoại mới của hãng SamSung với công nghệ hiện đại",
      "price": "1200.0",
      "image": "assets/samsung.jpg",
    },
    {
      "name": "Điện thoại 02",
      "desc": "Điện thoại mới của hãng Apple với công nghệ hiện đại",
      "price": "200.0",
      "image": "assets/iPhone.jpg",
    },
    {
      "name": "Điện thoại 04",
      "desc": "Điện thoại màn hình gập Z Fold",
      "price": "602.2",
      "image": "assets/zfold.jpg",
    },
  ];

  void _showAddCartDialog(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Xác nhận",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text("Bạn vừa thêm sản phẩm vào Giỏ hàng"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Không", style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  cartItems.add(product);
                });
                Navigator.of(context).pop();
              },
              child: const Text(
                "Đồng ý",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  void _goToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CartScreen()),
    ).then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 239, 168, 4),
        title: const Text(
          "Cửa hàng điện thoại",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.black),
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.black),
            onPressed: _goToCart,
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.blue,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFFEEEEEE)),
              accountName: const Text(
                "Phạm Anh Tuấn",
                style: TextStyle(color: Colors.black),
              ),
              accountEmail: const Text(
                "tuanpa@huit.edu.vn",
                style: TextStyle(color: Colors.black),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Image.asset('assets/logo.png'),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.store, color: Colors.black),
              title: const Text(
                "Cửa hàng",
                style: TextStyle(color: Colors.black),
              ),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart, color: Colors.black),
              title: const Text(
                "Giỏ hàng",
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                Navigator.pop(context);
                _goToCart();
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.black),
              title: const Text("Thoát", style: TextStyle(color: Colors.black)),
              onTap: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              "Chọn sản phẩm bạn muốn sử dụng",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: 350,
            padding: const EdgeInsets.only(left: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              itemBuilder: (context, index) {
                final prod = products[index];
                return _buildProductCard(
                  product: prod,
                  onAddTap: () => _showAddCartDialog(prod),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              "Sản phẩm được lựa chọn nhiều nhất",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard({
    required Map<String, dynamic> product,
    required VoidCallback onAddTap,
  }) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage(product["image"]),
                fit: BoxFit.cover,
              ),
            ),
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(8),
          ),
          const SizedBox(height: 10),
          Text(
            product["name"],
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            product["desc"],
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                product["price"],
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.tealAccent.shade400,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: onAddTap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void _showRemoveDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Xác nhận",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text("Bạn muốn loại bỏ sản phẩm này ra khỏi giỏ hàng"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Không", style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  cartItems.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: const Text(
                "Đồng ý",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showCheckoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Thanh toán",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text("Bạn đã thanh toán"),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  cartItems.clear();
                });
                Navigator.of(context).pop();
              },
              child: const Text("OK", style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 239, 168, 4),
        title: const Text(
          "Giỏ hàng của bạn",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child:
                cartItems.isEmpty
                    ? const Center(
                      child: Text(
                        "Chưa có sản phẩm nào",
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    )
                    : Column(
                      children: [
                        const Text(
                          "Giỏ hàng của bạn",
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: ListView.builder(
                            itemCount: cartItems.length,
                            itemBuilder: (context, index) {
                              final item = cartItems[index];
                              return ListTile(
                                title: Text(
                                  item["name"],
                                  style: const TextStyle(fontSize: 16),
                                ),
                                subtitle: Text(
                                  item["price"],
                                  style: const TextStyle(fontSize: 14),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.black,
                                  ),
                                  onPressed: () => _showRemoveDialog(index),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
          ),
          if (cartItems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: ElevatedButton(
                onPressed: _showCheckoutDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "Thanh toán",
                  style: TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
