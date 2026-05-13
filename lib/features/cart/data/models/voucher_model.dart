class Voucher {
  final String id;
  final String title;
  final String details;
  final String imagePath;

  final String discountType;
  final double discountValue;
  final double minimumOrder;

  Voucher({
    required this.id,
    required this.title,
    required this.details,
    required this.imagePath,
    required this.discountType,
    required this.discountValue,
    required this.minimumOrder,
  });

  factory Voucher.fromMap(
    Map<String, dynamic> map,
    String docId,
  ) {
    return Voucher(
      id: docId,
      title: map['title'] ?? '',
      details: map['details'] ?? '',
      imagePath: map['imagePath'] ?? '',

      discountType:
          map['discountType'] ?? '',

      discountValue:
          _toDouble(map['discountValue']),

      minimumOrder:
          _toDouble(map['minimumOrder']),
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}