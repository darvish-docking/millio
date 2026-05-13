class Address {
  final String id;
  final String label;
  final String fullName;
  final String country;
  final String street;
  final String city;
  final String phone;
  final String email;
  final bool isDefault;
  final double? latitude;
  final double? longitude;

  Address({
    required this.id,
    required this.label,
    required this.fullName,
    required this.country,
    required this.street,
    required this.city,
    required this.phone,
    required this.email,
    this.isDefault = false,
    this.latitude,
    this.longitude,
  });

  String get details => '$street, $city, $country';

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'fullName': fullName,
      'country': country,
      'street': street,
      'city': city,
      'phone': phone,
      'email': email,
      'isDefault': isDefault,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map, String docId) {
    return Address(
      id: docId,
      label: map['label'] ?? '',
      fullName: map['fullName'] ?? '',
      country: map['country'] ?? '',
      street: map['street'] ?? '',
      city: map['city'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      isDefault: map['isDefault'] ?? false,
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
    );
  }
}
