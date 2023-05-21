class Product {
  String id;
  String name;
  double price;
  String thumbnail;
  int? quantity;
  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.thumbnail,
    this.quantity,
  });

  static List<Product> parseProductList(map) {
    var list = map['data'] as List<dynamic>;
    return list.map((product) => Product.fromJson(product)).toList();
  }

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'].toString(),
        name: json["name"].toString(),
        price: double.parse(json["price"].toString()),
        thumbnail: json["thumbnail"].toString(),
        quantity: int.parse(json["quantity"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "thumbnail": thumbnail,
        'quantity': quantity
      };
}
