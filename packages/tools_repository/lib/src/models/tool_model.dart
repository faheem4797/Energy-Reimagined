import 'dart:convert';

import 'package:equatable/equatable.dart';

class ToolModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final String category;
  final int quantity;
  final String imageUrl;
  final int lastUpdated;

  const ToolModel({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.quantity,
    required this.imageUrl,
    required this.lastUpdated,
  });

  static const empty = ToolModel(
    id: '',
    name: '',
    description: '',
    category: '',
    quantity: 0,
    imageUrl: '',
    lastUpdated: 0,
  );

  ToolModel copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    int? quantity,
    String? imageUrl,
    int? lastUpdated,
  }) {
    return ToolModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'quantity': quantity,
      'imageUrl': imageUrl,
      'lastUpdated': lastUpdated,
    };
  }

  factory ToolModel.fromMap(Map<String, dynamic> map) {
    return ToolModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      quantity: map['quantity']?.toInt() ?? 0,
      imageUrl: map['imageUrl'] ?? '',
      lastUpdated: map['lastUpdated']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ToolModel.fromJson(String source) =>
      ToolModel.fromMap(json.decode(source));

  bool get isEmpty => this == ToolModel.empty;

  bool get isNotEmpty => this != ToolModel.empty;

  @override
  String toString() {
    return 'ToolModel(id: $id, name: $name, description: $description, category: $category, quantity: $quantity, imageUrl: $imageUrl, lastUpdated: $lastUpdated)';
  }

  @override
  List<Object> get props {
    return [
      id,
      name,
      description,
      category,
      quantity,
      imageUrl,
      lastUpdated,
    ];
  }
}
