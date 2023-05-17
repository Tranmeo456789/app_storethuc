import 'dart:async';
import 'package:app_storethuc/data/remote/user_service.dart';
import 'package:dio/dio.dart';

import 'package:app_storethuc/data/spref/spref.dart';
import 'package:app_storethuc/shared/constant.dart';
import 'package:app_storethuc/shared/model/user_data.dart';

class UserRepo {
  // ignore: prefer_final_fields
  UserService _userService;
  UserRepo({required UserService userService}) : _userService = userService;

  Future<UserData> signIn(String email, String pass) async {
    var c = Completer<UserData>();
    try {
      var response = await _userService.signIn(email, pass);
      var userData = UserData.fromJson(response.data['data']);

      // ignore: unnecessary_null_comparison
      if (userData != null) {
        SPref.instance.set(SPrefCache.KEY_TOKEN, userData.token.toString());
        c.complete(userData);
        // ignore: unused_local_variable
        var token = await SPref.instance.get(SPrefCache.KEY_TOKEN);
        //print(token);
      }
    } on DioError catch (e) {
      // ignore: avoid_print
      print(e.response?.data);
      c.completeError('Dang nhap that bai');
    } catch (e) {
      c.completeError(e);
    }

    return c.future;
  }

  Future<UserData> signUp(String name, String email, String pass) async {
    var c = Completer<UserData>();
    try {
      var response = await _userService.signUp(name, email, pass);
      var userData = UserData.fromJson(response.data['data']);

      // ignore: unnecessary_null_comparison
      if (userData != null) {
        SPref.instance.set(SPrefCache.KEY_TOKEN, userData.token.toString());
        c.complete(userData);
      }
    } on DioError catch (e) {
      // ignore: avoid_print
      print(e.response?.data);
      c.completeError('Dang ki that bai');
    } catch (e) {
      c.completeError(e);
    }

    return c.future;
  }
}
