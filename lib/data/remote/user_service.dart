import 'package:dio/dio.dart';
import 'package:app_storethuc/network/book_client.dart';

class UserService {
  Future<Response> signIn(String email, String pass) {
    return BookClient.instance.dio.post('/login', data: {
      'email': email,
      'password': pass,
    });
  }

  Future<Response> signUp(String name, String email, String pass) {
    return BookClient.instance.dio.post('/register', data: {
      'name': name,
      'email': email,
      'password': pass,
    });
  }
}
