import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String image;
  final String title;
  final String distance;
  final String rating;
  final String reviewCount;
  final double price;
  final String category;
  final bool isHotDeal;
  final String description;
  final Map<String, String> ingredients;

  Product({
    required this.id,
    required this.image,
    required this.title,
    required this.distance,
    required this.rating,
    required this.reviewCount,
    required this.price,
    required this.category,
    this.isHotDeal = false,
    this.description = "",
    this.ingredients = const {},
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image': image,
      'title': title,
      'distance': distance,
      'rating': rating,
      'reviewCount': reviewCount,
      'price': price,
      'category': category,
      'isHotDeal': isHotDeal,
      'description': description,
      'ingredients': ingredients,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map, String docId) {
    final rawIngredients = map['Ingredients'] ?? map['ingredients'];
    return Product(
      id: docId,
      image: map['image'] ?? '',
      title: map['title'] ?? '',
      distance: map['distance'] ?? '',
      rating: map['rating'] ?? '0.0',
      reviewCount: map['reviewCount']?.toString() ?? '0',
      price: (map['price'] ?? 0.0).toDouble(),
      category: map['category'] ?? 'Uncategorized',
      isHotDeal: map['isHotDeal'] ?? false,
      description: map['description'] ?? '',
      ingredients: rawIngredients is Map
          ? (rawIngredients as Map<dynamic, dynamic>)
              .map((k, v) => MapEntry(k.toString(), v.toString()))
          : {},
    );
  }
}
