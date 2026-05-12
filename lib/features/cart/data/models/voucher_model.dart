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
          (map['discountValue'] ?? 0)
              .toDouble(),

      minimumOrder:
          (map['minimumOrder'] ?? 0)
              .toDouble(),
    );
  }
}