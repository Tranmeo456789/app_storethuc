class Validation {
  // static isPhoneValid(String phone) {
  //   final regexPhone = RegExp(r'^[0-9]+$');
  //   return regexPhone.hasMatch(phone);
  // }

  static isEmailValid(String email) {
    final regexEmail = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return regexEmail.hasMatch(email);
  }

  static isPassValid(String pass) {
    return pass.length >= 6;
  }

  static isNameValid(String name) {
    return name.length > 5;
  }
}
