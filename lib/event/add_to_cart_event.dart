import 'package:app_storethuc/base/base_event.dart';
import 'package:app_storethuc/shared/model/product.dart';

class AddToCartEvent extends BaseEvent {
  Product product;

  AddToCartEvent(this.product);
}
