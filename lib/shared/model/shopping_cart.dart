class ShoppingCart {
  String? userId;
  int? totalCart;

  ShoppingCart({this.userId, this.totalCart});

  factory ShoppingCart.fromJson(Map<String, dynamic> json) => ShoppingCart(
        userId: json['user_id'].toString(),
        totalCart: int.tryParse(json['total_cart'].toString()) ?? 0,
      );
}
