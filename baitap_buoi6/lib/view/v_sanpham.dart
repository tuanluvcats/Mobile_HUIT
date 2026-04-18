import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/sanpham.dart';
import '../provider/sanpham_provider.dart';

class SanPhamListScreen extends StatefulWidget {
  const SanPhamListScreen({super.key});

  @override
  State<SanPhamListScreen> createState() => _SanPhamListScreenState();
}

class _SanPhamListScreenState extends State<SanPhamListScreen> {
  @override
  void initState() {
    super.initState();
    // Nạp dữ liệu từ database khi màn hình vừa mở
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SanPhamProvider>().loadSanPhams();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản lý sản phẩm"),
        backgroundColor: Colors.teal,
      ),
      body: Consumer<SanPhamProvider>(
        builder: (context, provider, child) {
          if (provider.dsSanPham.isEmpty) {
            return const Center(child: Text("Chưa có sản phẩm nào"));
          }
          return ListView.builder(
            itemCount: provider.dsSanPham.length,
            itemBuilder: (context, index) {
              final sp = provider.dsSanPham[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: ListTile(
                  isThreeLine: true,
                  title: Text(
                    "${sp.ma} - ${sp.ten}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hiển thị 5 thông tin theo yêu cầu
                        Text("Đơn giá: ${sp.gia} VNĐ"),
                        Text("Giảm giá: ${sp.giamGia} VNĐ"),
                        Text(
                          "Thuế nhập khẩu (10%): ${sp.tinhThueNhapKhau()} VNĐ",
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.grey),
                    onPressed: () => provider.deleteSanPham(sp.ma),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
      ),
    );
  }

  // Hộp thoại nhập liệu sản phẩm mới
  void _showAddDialog(BuildContext context) {
    final maController = TextEditingController();
    final tenController = TextEditingController();
    final giaController = TextEditingController();
    final giamGiaController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Thêm Sản Phẩm Mới"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: maController,
                    decoration: const InputDecoration(labelText: "Mã sản phẩm"),
                  ),
                  TextField(
                    controller: tenController,
                    decoration: const InputDecoration(
                      labelText: "Tên sản phẩm",
                    ),
                  ),
                  TextField(
                    controller: giaController,
                    decoration: const InputDecoration(labelText: "Đơn giá"),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: giamGiaController,
                    decoration: const InputDecoration(labelText: "Giảm giá"),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Hủy"),
              ),
              ElevatedButton(
                onPressed: () {
                  final sp = SanPham(
                    ma: maController.text,
                    ten: tenController.text,
                    gia: double.tryParse(giaController.text) ?? 0.0,
                    giamGia: double.tryParse(giamGiaController.text) ?? 0.0,
                  );
                  context.read<SanPhamProvider>().addSanPham(sp);
                  Navigator.pop(context);
                },
                child: const Text("Lưu"),
              ),
            ],
          ),
    );
  }
}
