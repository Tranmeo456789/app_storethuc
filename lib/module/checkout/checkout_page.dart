import 'package:flutter/material.dart';
import 'package:app_storethuc/base/base_event.dart';
import 'package:app_storethuc/base/base_widget.dart';
import 'package:app_storethuc/data/remote/order_service.dart';
import 'package:app_storethuc/data/repo/order_repo.dart';
import 'package:app_storethuc/event/confirm_order_event.dart';
import 'package:app_storethuc/event/pop_event.dart';
import 'package:app_storethuc/event/update_cart_event.dart';
import 'package:app_storethuc/module/checkout/checkout_bloc.dart';
import 'package:app_storethuc/shared/app_color.dart';
import 'package:app_storethuc/shared/model/order.dart';
import 'package:app_storethuc/shared/model/product.dart';
import 'package:app_storethuc/shared/model/rest_error.dart';
import 'package:app_storethuc/shared/widget/bloc_listener.dart';
import 'package:app_storethuc/shared/widget/btn_cart_action.dart';
import 'package:app_storethuc/shared/widget/normal_button.dart';
//import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Object? userId = ModalRoute.of(context)?.settings.arguments;
    return PageContainer(
      title: 'Checkout',
      di: [
        Provider.value(
          value: userId,
        ),
        Provider.value(
          value: OrderService(),
        ),
        ProxyProvider2<OrderService, String, OrderRepo>(
          update: (context, orderService, userId, previous) => OrderRepo(
            orderService: orderService,
            userId: userId,
          ),
        ),
      ],
      bloc: const [],
      child: const ShoppingCartContainer(),
    );
  }
}

class ShoppingCartContainer extends StatefulWidget {
  const ShoppingCartContainer({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ShoppingCartContainerState createState() => _ShoppingCartContainerState();
}

class _ShoppingCartContainerState extends State<ShoppingCartContainer> {
  handleEvent(BaseEvent event) {
    if (event is ShouldPopEvent) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CheckoutBloc(
        orderRepo: Provider.of(context),
      ),
      child: Consumer<CheckoutBloc>(
        builder: (context, bloc, child) => BlocListener<CheckoutBloc>(
          listener: handleEvent,
          child: ShoppingCart(bloc),
        ),
      ),
    );
  }
}

class ShoppingCart extends StatefulWidget {
  final CheckoutBloc bloc;
  const ShoppingCart(this.bloc, {super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  @override
  void initState() {
    super.initState();
    widget.bloc.getOrderDetail();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<Object?>.value(
      value: widget.bloc.orderStream,
      initialData: null,
      catchError: (context, err) {
        return err;
      },
      child: Consumer<Object?>(
        builder: (context, data, child) {
          if (data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (data is RestError) {
            return Center(child: Text('${data.message}'));
          }

          if (data is Order) {
            return Column(
              children: <Widget>[
                Expanded(
                  child: ProductListWidget(data.items),
                ),
                ConfirmInfoWidget(data.total as double),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}

class ConfirmInfoWidget extends StatelessWidget {
  final double total;
  const ConfirmInfoWidget(this.total, {super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CheckoutBloc>(builder: (context, bloc, child) {
      return SizedBox(
        height: 170,
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$total',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600,
                  color: AppColor.blue),
            ),
            const SizedBox(
              height: 20.0,
            ),
            NormalButton(
              title: 'Confirm',
              onPressed: () {
                bloc.event.add(ConfirmOrderEvent());
              },
              enable: null,
            ),
          ],
        ),
      );
    });
  }
}

class ProductListWidget extends StatelessWidget {
  final List<Product>? productList;

  const ProductListWidget(this.productList, {super.key});

  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<CheckoutBloc>(context);
    productList?.sort((p1, p2) => p1.price.compareTo(p2.price));
    return ListView.builder(
      itemCount: productList?.length,
      itemBuilder: (context, index) => _buildRow(productList![index], bloc),
    );
  }

  Widget _buildRow(Product product, CheckoutBloc bloc) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                product.thumbnail,
                width: 90,
                height: 140,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(
              width: 15.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 15.0,
                        height: 1.2,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'Giá: ${product.price}',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  _buildCartAction(product, bloc),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartAction(Product product, CheckoutBloc bloc) {
    return Row(
      children: <Widget>[
        BtnCartAction(
          title: '-',
          onPressed: () {
            // if (product.quantity == 1) {
            //   return;
            // }
            // product.quantity = product.quantity - 1;
            bloc.event.add(UpdateCartEvent(product));
          },
        ),
        const SizedBox(
          width: 15,
        ),
        const Text('1',
            style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: Colors.red)),
        const SizedBox(
          width: 15,
        ),
        BtnCartAction(
          title: '+',
          onPressed: () {
            // product.quantity = product.quantity + 1;
            bloc.event.add(UpdateCartEvent(product));
          },
        ),
      ],
    );
  }
}
