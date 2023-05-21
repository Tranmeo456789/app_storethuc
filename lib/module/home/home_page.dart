import 'package:app_storethuc/shared/widget/txt_fomat_money.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:app_storethuc/base/base_widget1.dart';
import 'package:app_storethuc/data/remote/order_service.dart';
import 'package:app_storethuc/data/remote/product_service.dart';
import 'package:app_storethuc/data/repo/order_repo.dart';
import 'package:app_storethuc/data/repo/product_repo.dart';
import 'package:app_storethuc/event/add_to_cart_event.dart';
import 'package:app_storethuc/module/home/home_bloc.dart';
import 'package:app_storethuc/shared/app_color.dart';
import 'package:app_storethuc/shared/model/product.dart';
import 'package:app_storethuc/shared/model/rest_error.dart';
import 'package:app_storethuc/shared/model/shopping_cart.dart';
// ignore: import_of_legacy_library_into_null_safe
//import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageContainer1(
      title: 'Trang chủ',
      di: [
        Provider.value(
          value: ProductService(),
        ),
        Provider.value(
          value: OrderService(),
        ),
        ProxyProvider<ProductService, ProductRepo>(
          update: (context, productService, previous) =>
              ProductRepo(productService: productService),
        ),
        ProxyProvider<OrderService, OrderRepo>(
          update: (context, orderService, previous) =>
              OrderRepo(orderService: orderService, userId: ''),
        ),
      ],
      bloc: const [],
      actions: const <Widget>[
        ShoppingCartWidget(),
      ],
      child: const ProductListWidget(),
    );
  }
}

class ShoppingCartWidget extends StatelessWidget {
  const ShoppingCartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: HomeBloc.getInstance(
        productRepo: Provider.of(context),
        orderRepo: Provider.of(context),
      ),
      child: const CartWidget(),
    );
  }
}

class CartWidget extends StatefulWidget {
  const CartWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    var bloc = Provider.of<HomeBloc>(context);
    bloc.getShoppingCartInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeBloc>(
      builder: (context, bloc, child) => StreamProvider<Object?>.value(
        value: bloc.shoppingCartStream,
        initialData: const [],
        catchError: (context, error) {
          return error!;
        },
        child: Consumer<Object?>(
          builder: (context, data, child) {
            if (data != null && data is ShoppingCart) {
              var cart = data;
              return GestureDetector(
                onTap: () {
                  // ignore: unnecessary_null_comparison
                  if (data == null) {
                    return;
                  }
                  Navigator.pushNamed(context, '/checkout',
                      arguments: cart.userId.toString());
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 15, right: 20),
                  child: badges.Badge(
                    badgeContent: Text(
                      '${cart.totalCart}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Icon(Icons.shopping_cart),
                  ),
                ),
              );
            } else if (data is RestError) {
              return Container(
                margin: const EdgeInsets.only(top: 15, right: 20),
                child: Text('${data.message}'),
              );
            } else {
              return Container(
                margin: const EdgeInsets.only(top: 15, right: 20),
                child: const Icon(Icons.cabin),
              );
            }
          },
        ),
      ),
    );
  }
}

class ProductListWidget extends StatelessWidget {
  const ProductListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: HomeBloc.getInstance(
        productRepo: Provider.of(context),
        orderRepo: Provider.of(context),
      ),
      child: Consumer<HomeBloc?>(
        // ignore: avoid_unnecessary_containers
        builder: (context, bloc, child) => Container(
          child: StreamProvider<Object?>.value(
            value: bloc?.getProductList(),
            initialData: null,
            catchError: (context, error) {
              return error;
            },
            child: Consumer<Object?>(
              builder: (context, data, child) {
                // ignore: unnecessary_null_comparison
                if (data == null) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: AppColor.yellow,
                    ),
                  );
                }

                if (data is RestError) {
                  return Center(
                    // ignore: avoid_unnecessary_containers
                    child: Container(
                      child: const Text(
                        'loi',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  );
                } else {
                  var products = data as List<Product>;
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return _buildRow(bloc!, products[index]);
                      });
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(HomeBloc bloc, Product product) {
    // ignore: sized_box_for_whitespace
    return Container(
      height: 150,
      child: Card(
        elevation: 3.0,
        child: Container(
          padding: const EdgeInsets.only(left: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 90,
                  width: 90,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          "https://storethuc.xyz/public/${product.thumbnail}"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin:
                          const EdgeInsets.only(top: 15, left: 15, right: 10),
                      child: Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5, left: 15),
                      child: Text(
                        'Đơn vị: Kg',
                        style: TextStyle(color: AppColor.blue, fontSize: 17),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(top: 5, left: 15),
                            child: TxtFomatMoney(value: product.price),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 15),
                            child: TextButton(
                              // ignore: prefer_const_constructors
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.all(10),
                                backgroundColor: AppColor.yellow,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4),
                                    topRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                bloc.event.add(AddToCartEvent(product));
                              },
                              child: const Text(
                                ' Buy now ',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
