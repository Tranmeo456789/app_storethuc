import 'package:app_storethuc/base/base_event.dart';

class SignUpEvent extends BaseEvent {
  String name;
  String email;
  String pass;

  SignUpEvent({
    required this.name,
    required this.email,
    required this.pass,
  });
}
