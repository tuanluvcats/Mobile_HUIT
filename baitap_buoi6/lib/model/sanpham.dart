class SanPham {
  final String ma;
  final String ten;
  final double gia;
  final double giamGia;

  SanPham({
    required this.ma,
    required this.ten,
    required this.gia,
    required this.giamGia,
  });

  double tinhThueNhapKhau() => gia * 0.1;

  Map<String, dynamic> toMap() {
    return {'ma': ma, 'ten': ten, 'gia': gia, 'giamGia': giamGia};
  }

  factory SanPham.fromMap(Map<String, dynamic> map) {
    return SanPham(
      ma: map['ma'] ?? '',
      ten: map['ten'] ?? '',
      gia: map['gia']?.toDouble() ?? 0.0,
      giamGia: map['giamGia']?.toDouble() ?? 0.0,
    );
  }
}
