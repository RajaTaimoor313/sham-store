class OrderItem {
  final String imageUrl;
  final String name;
  final int pieces;
  final double price;
  final String status; // "Completed", "In Progress", or "Cancelled"

  OrderItem({
    required this.imageUrl,
    required this.name,
    required this.pieces,
    required this.price,
    required this.status,
  });
}
