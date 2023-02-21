class Product {
  Product({
    required this.name,
    required this.price,
    required this.quantity,
    required this.position,
  });

  final String name;
  final int price;
  int quantity;
  final String position;

  void increaseQuantity() {
    quantity++;
  }

  void decreaseQuantity() {
    quantity--;
  }
}
