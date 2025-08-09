import 'package:flutter/material.dart';

class Category {
  final int id;
  final String name;
  final String? description;
  final String? image;
  final String? icon;
  final String? colorHex;
  final int? parentId;
  final int sortOrder;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<Category>? subcategories;
  final int? productCount;

  Category({
    required this.id,
    required this.name,
    this.description,
    this.image,
    this.icon,
    this.colorHex,
    this.parentId,
    required this.sortOrder,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
    this.subcategories,
    this.productCount,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'],
      image: json['image'],
      icon: json['icon'],
      colorHex: json['color_hex'],
      parentId: json['parent_id'],
      sortOrder: json['sort_order'] ?? 0,
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      subcategories: json['subcategories'] != null
          ? (json['subcategories'] as List)
                .map((subcat) => Category.fromJson(subcat))
                .toList()
          : null,
      productCount: json['product_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'icon': icon,
      'color_hex': colorHex,
      'parent_id': parentId,
      'sort_order': sortOrder,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // Helper getters
  Color get color {
    if (colorHex != null && colorHex!.isNotEmpty) {
      return Color(int.parse(colorHex!.replaceFirst('#', '0xff')));
    }
    return Colors.blue; // Default color
  }

  IconData get iconData {
    if (icon != null) {
      switch (icon!.toLowerCase()) {
        case 'electronics':
        case 'devices':
          return Icons.devices;
        case 'fashion':
        case 'clothing':
        case 'clothes':
          return Icons.checkroom;
        case 'books':
        case 'book':
          return Icons.book;
        case 'home':
        case 'house':
          return Icons.home;
        case 'sports':
        case 'sport':
          return Icons.sports;
        case 'beauty':
        case 'cosmetics':
          return Icons.face;
        case 'toys':
        case 'toy':
          return Icons.toys;
        case 'automotive':
        case 'car':
        case 'vehicle':
          return Icons.directions_car;
        case 'food':
        case 'restaurant':
          return Icons.restaurant;
        case 'health':
        case 'medical':
          return Icons.medical_services;
        case 'music':
          return Icons.music_note;
        case 'gaming':
        case 'games':
          return Icons.games;
        case 'travel':
          return Icons.flight;
        case 'pets':
        case 'pet':
          return Icons.pets;
        default:
          return Icons.category;
      }
    }
    return Icons.category;
  }

  bool get hasSubcategories =>
      subcategories != null && subcategories!.isNotEmpty;
  bool get isParentCategory => parentId == null;
  bool get isSubcategory => parentId != null;

  String get displayProductCount {
    if (productCount == null) return '';
    return productCount == 1 ? '1 product' : '$productCount products';
  }
}

// For backward compatibility
typedef CategoryModel = Category;
