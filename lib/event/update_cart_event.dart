import 'package:app_storethuc/base/base_event.dart';
import 'package:app_storethuc/shared/model/product.dart';

class UpdateCartEvent extends BaseEvent {
  Product product;
  UpdateCartEvent(this.product);
}
