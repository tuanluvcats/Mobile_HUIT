import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/chitieu.dart';
import '../provider/chitieu_provider.dart';

class ChiTieuListScreen extends StatefulWidget {
  const ChiTieuListScreen({super.key});

  @override
  State<ChiTieuListScreen> createState() => _ChiTieuListScreenState();
}

class _ChiTieuListScreenState extends State<ChiTieuListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChiTieuProvider>().loadChiTieus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Quản lý chi tiêu cá nhân",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Consumer<ChiTieuProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              Expanded(
                child:
                    provider.dsChiTieu.isEmpty
                        ? const Center(child: Text("Chưa có chi tiêu nào"))
                        : ListView.builder(
                          padding: const EdgeInsets.all(10),
                          itemCount: provider.dsChiTieu.length,
                          itemBuilder: (context, index) {
                            final ct = provider.dsChiTieu[index];
                            return Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              child: ListTile(
                                leading: const Icon(
                                  Icons.money_off,
                                  color: Colors.redAccent,
                                ),
                                title: Text(
                                  ct.noidung,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Text("Ghi chú: ${ct.ghichu}"),
                                trailing: Text(
                                  "${ct.sotien} VNĐ",
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                onLongPress:
                                    () => provider.deleteChiTieu(ct.id!),
                              ),
                            );
                          },
                        ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 25,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: const Border(
                    top: BorderSide(color: Colors.black12, width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    const Text(
                      "Tổng chi tiêu: ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "${provider.tongChiTieu} VNĐ",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(width: 60),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        backgroundColor: Colors.purple[100],
        child: const Icon(Icons.add, color: Colors.deepPurple),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final noiDungController = TextEditingController();
    final soTienController = TextEditingController();
    final ghiChuController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text("Thêm chi tiêu mới"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: noiDungController,
                    decoration: const InputDecoration(
                      labelText: "Nội dung chi",
                    ),
                  ),
                  TextField(
                    controller: soTienController,
                    decoration: const InputDecoration(labelText: "Số tiền"),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: ghiChuController,
                    decoration: const InputDecoration(labelText: "Ghi chú"),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Hủy",
                  style: TextStyle(color: Colors.purple),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  if (noiDungController.text.isNotEmpty &&
                      soTienController.text.isNotEmpty) {
                    final ct = ChiTieu(
                      noidung: noiDungController.text,
                      sotien: double.tryParse(soTienController.text) ?? 0.0,
                      ghichu: ghiChuController.text,
                    );
                    context.read<ChiTieuProvider>().addChiTieu(ct);
                    Navigator.pop(context);
                  }
                },
                child: const Text("Lưu"),
              ),
            ],
          ),
    );
  }
}
