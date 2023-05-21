import 'package:dio/dio.dart';
import 'package:app_storethuc/network/book_client.dart';
import 'package:app_storethuc/shared/model/product.dart';

class OrderService {
  Future<Response> countShoppingCart() {
    return BookClient.instance.dio.get(
      '/cart/count',
    );
  }

  Future<Response> addToCart(Product product) {
    return BookClient.instance.dio.post('/cart/add', data: {
      'product': product.toJson(),
    });
  }

  Future<Response> orderDetail(String userId) {
    return BookClient.instance.dio.get(
      '/cart/detail',
      queryParameters: {
        'user_id': userId,
      },
    );
  }

  Future<Response> updateOrder(Product product) {
    return BookClient.instance.dio.post(
      '/cart/update',
      data: {
        //'userId': product.userId,
        'quantity': product.quantity,
        'productId': product.id,
      },
    );
  }

  Future<Response> confirm(String userId) {
    return BookClient.instance.dio.post(
      '/order/confirm',
      data: {
        'userId': userId,
        'status': 'CONFIRM',
      },
    );
  }
}
