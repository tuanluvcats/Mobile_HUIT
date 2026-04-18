class ChiTieu {
  final int? id;
  final String noidung;
  final double sotien;
  final String ghichu;

  ChiTieu({
    this.id,
    required this.noidung,
    required this.sotien,
    required this.ghichu,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'noidung': noidung, 'sotien': sotien, 'ghichu': ghichu};
  }

  factory ChiTieu.fromMap(Map<String, dynamic> map) {
    return ChiTieu(
      id: map['id'],
      noidung: map['noidung'] ?? '',
      sotien: map['sotien']?.toDouble() ?? 0.0,
      ghichu: map['ghichu'] ?? '',
    );
  }
}
