import 'package:app_storethuc/base/base_event.dart';

class SignInEvent extends BaseEvent {
  String email;
  String pass;

  SignInEvent({
    required this.email,
    required this.pass,
  });
}
