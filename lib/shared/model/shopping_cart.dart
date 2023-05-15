class ShoppingCart {
  int? userId;
  int? totalCart;

  ShoppingCart({this.userId, this.totalCart});

  factory ShoppingCart.fromJson(Map<String, dynamic> json) => ShoppingCart(
        userId: int.tryParse(json['user_id'].toString()) ?? 0,
        totalCart: int.tryParse(json['total_cart'].toString()) ?? 0,
      );
}
