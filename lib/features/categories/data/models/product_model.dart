class Product {
  final int id;
  final String name;
  final String? description;
  final double price;
  final String? imageUrl;
  final int categoryId;
  final String? sku;
  final int stock;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<ProductGallery>? gallery;
  final List<ProductAttribute>? attributes;
  final ProductShipping? shipping;
  final List<ProductPricingTier>? pricingTiers;
  final double discountPrice;
  final List<String> images;
  final String category;
  final String brand;
  final double rating;

  Product({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.imageUrl,
    required this.categoryId,
    this.sku,
    required this.stock,
    required this.status,
    this.createdAt,
    this.updatedAt,
    this.gallery,
    this.attributes,
    this.shipping,
    this.pricingTiers,
    required this.discountPrice,
    required this.images,
    required this.category,
    required this.brand,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name'] ?? '',
      description: json['description'],
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      imageUrl: json['image_url'] ?? json['featured_image'],
      categoryId: int.tryParse(json['category_id']?.toString() ?? '0') ?? 0,
      sku: json['sku'],
      stock: int.tryParse(json['stock']?.toString() ?? '0') ?? 0,
      status: json['status'] ?? 'active',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      gallery: json['gallery'] != null
          ? (json['gallery'] as List)
                .map((g) => ProductGallery.fromJson(g))
                .toList()
          : null,
      attributes: json['attributes'] != null
          ? (json['attributes'] as List)
                .map((a) => ProductAttribute.fromJson(a))
                .toList()
          : null,
      shipping: json['shipping'] != null
          ? ProductShipping.fromJson(json['shipping'])
          : null,
      pricingTiers: json['pricing_tiers'] != null
          ? (json['pricing_tiers'] as List)
                .map((p) => ProductPricingTier.fromJson(p))
                .toList()
          : null,
      discountPrice:
          double.tryParse(json['discount_price']?.toString() ?? '0') ?? 0.0,
      images: json['images'] != null
          ? List<String>.from(json['images'])
          : [json['image_url'] ?? json['featured_image'] ?? ''],
      category: json['category'] ?? '',
      brand: json['brand'] ?? '',
      rating: double.tryParse(json['rating']?.toString() ?? '0') ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image_url': imageUrl,
      'category_id': categoryId,
      'sku': sku,
      'stock': stock,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'discount_price': discountPrice,
      'images': images,
      'category': category,
      'brand': brand,
      'rating': rating,
    };
  }

  // Helper getters
  String get displayPrice => '\$${price.toStringAsFixed(2)}';
  bool get isInStock => stock > 0;
  bool get isActive => status.toLowerCase() == 'active';
  String get displayImage => imageUrl ?? 'https://picsum.photos/150/150';
}

// Product Gallery Model
class ProductGallery {
  final int id;
  final int productId;
  final String imageUrl;
  final String? altText;
  final int sortOrder;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProductGallery({
    required this.id,
    required this.productId,
    required this.imageUrl,
    this.altText,
    required this.sortOrder,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductGallery.fromJson(Map<String, dynamic> json) {
    return ProductGallery(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      productId: int.tryParse(json['product_id']?.toString() ?? '0') ?? 0,
      imageUrl: json['image_url'] ?? '',
      altText: json['alt_text'],
      sortOrder: int.tryParse(json['sort_order']?.toString() ?? '0') ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }
}

// Product Attribute Model
class ProductAttribute {
  final int id;
  final int productId;
  final String name;
  final String value;
  final String? type;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProductAttribute({
    required this.id,
    required this.productId,
    required this.name,
    required this.value,
    this.type,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductAttribute.fromJson(Map<String, dynamic> json) {
    return ProductAttribute(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      productId: int.tryParse(json['product_id']?.toString() ?? '0') ?? 0,
      name: json['name'] ?? '',
      value: json['value'] ?? '',
      type: json['type'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }
}

// Product Shipping Model
class ProductShipping {
  final int id;
  final int productId;
  final double weight;
  final String? dimensions;
  final double shippingCost;
  final String? shippingMethod;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProductShipping({
    required this.id,
    required this.productId,
    required this.weight,
    this.dimensions,
    required this.shippingCost,
    this.shippingMethod,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductShipping.fromJson(Map<String, dynamic> json) {
    return ProductShipping(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      productId: int.tryParse(json['product_id']?.toString() ?? '0') ?? 0,
      weight: double.tryParse(json['weight']?.toString() ?? '0') ?? 0.0,
      dimensions: json['dimensions'],
      shippingCost:
          double.tryParse(json['shipping_cost']?.toString() ?? '0') ?? 0.0,
      shippingMethod: json['shipping_method'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }
}

// Product Pricing Tier Model
class ProductPricingTier {
  final int id;
  final int productId;
  final int minQuantity;
  final int? maxQuantity;
  final double price;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProductPricingTier({
    required this.id,
    required this.productId,
    required this.minQuantity,
    this.maxQuantity,
    required this.price,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductPricingTier.fromJson(Map<String, dynamic> json) {
    return ProductPricingTier(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      productId: int.tryParse(json['product_id']?.toString() ?? '0') ?? 0,
      minQuantity: int.tryParse(json['min_quantity']?.toString() ?? '1') ?? 1,
      maxQuantity: json['max_quantity'] != null
          ? int.tryParse(json['max_quantity']?.toString() ?? '0')
          : null,
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }
}
