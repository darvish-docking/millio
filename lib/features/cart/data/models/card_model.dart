class CardInfo {
  final String id;
  final String cardHolderName;
  final String lastFourDigits;
  final String cardNetwork;
  final String expiryDate;
  final bool isDefault;

  CardInfo({
    required this.id,
    required this.cardHolderName,
    required this.lastFourDigits,
    required this.cardNetwork,
    required this.expiryDate,
    this.isDefault = false,
  });

  String get maskedNumber => '**** **** **** $lastFourDigits';

  Map<String, dynamic> toMap() {
    return {
      'cardHolderName': cardHolderName,
      'lastFourDigits': lastFourDigits,
      'cardNetwork': cardNetwork,
      'expiryDate': expiryDate,
      'isDefault': isDefault,
    };
  }

  factory CardInfo.fromMap(Map<String, dynamic> map, String docId) {
    return CardInfo(
      id: docId,
      cardHolderName: map['cardHolderName'] ?? '',
      lastFourDigits: map['lastFourDigits'] ?? '',
      cardNetwork: map['cardNetwork'] ?? '',
      expiryDate: map['expiryDate'] ?? '',
      isDefault: map['isDefault'] ?? false,
    );
  }
}

String detectCardNetwork(String cardNumber) {
  final cleaned = cardNumber.replaceAll(' ', '');
  if (cleaned.startsWith('4')) return 'visa';
  if (cleaned.startsWith('5')) return 'mastercard';
  if (cleaned.startsWith('3')) return 'amex';
  if (cleaned.startsWith('6')) return 'discover';
  return 'card';
}
