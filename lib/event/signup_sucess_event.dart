import 'package:app_storethuc/base/base_event.dart';
import 'package:app_storethuc/shared/model/user_data.dart';

class SignUpSuccessEvent extends BaseEvent {
  final UserData userData;
  SignUpSuccessEvent(this.userData);
}
