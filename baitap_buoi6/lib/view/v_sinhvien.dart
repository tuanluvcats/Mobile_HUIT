class _SinhVienListScreen00State extends State<SinhVienListScreen00> {
late Future<List<SinhVien>> svs;
final DatabaseHelper db = DatabaseHelper();
@override
void initState() {
super.initState();
_initDatabase();
}