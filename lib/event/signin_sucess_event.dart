import 'package:app_storethuc/base/base_event.dart';
import 'package:app_storethuc/shared/model/user_data.dart';

class SignInSuccessEvent extends BaseEvent {
  final UserData userData;
  SignInSuccessEvent(this.userData);
}
