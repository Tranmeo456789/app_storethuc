import 'dart:async';

import 'package:dio/dio.dart';
import 'package:app_storethuc/data/remote/product_service.dart';
import 'package:app_storethuc/shared/model/product.dart';
import 'package:app_storethuc/shared/model/rest_error.dart';

class ProductRepo {
  final ProductService _productService;

  ProductRepo({required ProductService productService})
      : _productService = productService;

  Future<List<Product>> getProductList() async {
    var c = Completer<List<Product>>();
    try {
      var response = await _productService.getProductList();
      var productList = Product.parseProductList(response.data);
      print(productList.toString());
      c.complete(productList);
    } on DioError {
      c.completeError(RestError.fromData('Không có dữ liệu'));
    } catch (e) {
      c.completeError(e);
    }
    return c.future;
  }
}
