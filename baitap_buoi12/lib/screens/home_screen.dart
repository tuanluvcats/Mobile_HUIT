import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants/api_constants.dart';

class HomeScreen extends StatefulWidget {
  final int userID;
  const HomeScreen({super.key, required this.userID});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _results = [];
  bool _isLoading = true;
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    _fetchResults();
  }

  Future<void> _fetchResults() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/results/${widget.userID}'),
      );
      if (!mounted) return;
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _results = data.map((item) => item as Map<String, dynamic>).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = "Không có dữ liệu bảng điểm!";
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = "Lỗi kết nối Server: $e";
        _isLoading = false;
      });
    }
  }

  Color _getGradeColor(String grade) {
    switch (grade.toUpperCase()) {
      case 'A': return Colors.green;
      case 'B': return Colors.blue;
      case 'C': return Colors.orange;
      case 'D': return Colors.yellow;
      case 'F': return Colors.red;
      default: return Colors.black;
    }
  }

  Widget _buildResultsTable(List<Map<String, dynamic>> results) {
    if (results.isEmpty) return const Center(child: Text("Sinh viên chưa có điểm", style: TextStyle(fontSize: 16)));
    final Map<String, List<Map<String, dynamic>>> groupedResults = {};
    for (var result in results) {
      String getStr(String key1, String key2) => (result[key1] ?? result[key2] ?? '').toString();    
      String academicYear = getStr('academicYear', 'AcademicYear');
      String semester = getStr('semester', 'Semester');   
      final key = "$academicYear - $semester";
      groupedResults.putIfAbsent(key, () => []).add(result);
    }
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: groupedResults.entries.map((entry) {
        return Card(
          elevation: 4.0, margin: const EdgeInsets.only(bottom: 16.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.key, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue.shade800)),
                const SizedBox(height: 8.0),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 20.0,
                    headingRowColor: WidgetStateProperty.all(Colors.blue.shade50),
                    columns: const [
                      DataColumn(label: Text("Mã MH", style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("Tên môn", style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("Đ.QT", style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("Đ.Thi", style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("Loại", style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: entry.value.map((res) {
                      String getStr(String key1, String key2) => (res[key1] ?? res[key2] ?? '').toString();                     
                      String subjCode = getStr('subjectCode', 'SubjectCode');
                      String subjName = getStr('subjectName', 'SubjectName');
                      String process = getStr('processScore', 'ProcessScore');
                      String exam = getStr('examScore', 'ExamScore');
                      String finalG = getStr('finalGrade', 'FinalGrade');

                      return DataRow(cells: [
                        DataCell(Text(subjCode)),
                        DataCell(Text(subjName)),
                        DataCell(Text(process)),
                        DataCell(Text(exam)),
                        DataCell(Text(finalG, style: TextStyle(color: _getGradeColor(finalG), fontWeight: FontWeight.bold, fontSize: 16))),
                      ]);
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("KẾT QUẢ HỌC TẬP", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), 
        backgroundColor: Colors.blue.shade700, 
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue.shade700), 
              child: const Text("Menu", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold))
            ),
            ListTile(leading: const Icon(Icons.person), title: const Text("Thông tin cá nhân"), onTap: () {}),
            ListTile(leading: const Icon(Icons.settings), title: const Text("Cài đặt"), onTap: () {}),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.red), 
              title: const Text("Thoát", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)), 
              onTap: () {

                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              }
            ),
          ],
        ),
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator()) 
          : _errorMessage.isNotEmpty 
              ? Center(child: Text(_errorMessage, style: const TextStyle(color: Colors.red, fontSize: 16))) 
              : _buildResultsTable(_results),
    );
  }
}