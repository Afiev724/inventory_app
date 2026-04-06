class Item {
  String id;
  String name;
  int quantity;
  double price;

  Item({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'price': price,
    };
  }

  factory Item.fromMap(String id, Map<String, dynamic> map) {
    return Item(
      id: id,
      name: map['name'],
      quantity: map['quantity'],
      price: map['price'],
    );
  }
}