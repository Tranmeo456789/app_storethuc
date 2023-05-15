import 'dart:async';
import 'package:app_storethuc/base/base_bloc.dart';
import 'package:app_storethuc/base/base_event.dart';
import 'package:app_storethuc/data/repo/user_repo.dart';
import 'package:app_storethuc/event/signin_fail_event.dart';
import 'package:app_storethuc/event/signin_sucess_event.dart';
import 'package:app_storethuc/event/singin_event.dart';
import 'package:app_storethuc/shared/model/user_data.dart';
import 'package:app_storethuc/shared/validation.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

class SignInBloc extends BaseBloc with ChangeNotifier {
  final _emailSubject = BehaviorSubject<String>();
  final _passSubject = BehaviorSubject<String>();
  final _btnSubject = BehaviorSubject<bool>();

  final _userSubject = BehaviorSubject<UserData>();
  late UserRepo _userRepo;

  SignInBloc({required UserRepo userRepo}) {
    _userRepo = userRepo;
    //btnSink.add(true);
    validateForm();
  }

  var emailValidation =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (Validation.isEmailValid(email)) {
      sink.add('');
      return;
    }
    sink.add('Email invalid');
  });
  var passValidation =
      StreamTransformer<String, String>.fromHandlers(handleData: (pass, sink) {
    if (Validation.isPassValid(pass)) {
      sink.add('');
      return;
    }
    sink.add('Password too short');
  });

  Stream<String> get emailStream =>
      _emailSubject.stream.transform(emailValidation);
  Sink<String> get emailSink => _emailSubject.sink;

  Stream<String> get passStream =>
      _passSubject.stream.transform(passValidation);
  Sink<String> get passSink => _passSubject.sink;

  // Stream<bool> get btnStream =>
  // Rx.combineLatest2(emailStream, passStream, (e, p) => true);
  Stream<bool> get btnStream => _btnSubject.stream;
  Sink<bool> get btnSink => _btnSubject.sink;

  Stream<UserData> get userStream => _userSubject.stream;
  Sink<UserData> get userSink => _userSubject.sink;
  validateForm() {
    Rx.combineLatest2(
      _emailSubject,
      _passSubject,
      (email, pass) {
        return Validation.isEmailValid(email) && Validation.isPassValid(pass);
      },
    ).listen((enable) => btnSink.add(enable));
  }

  @override
  void dispatchEvent(BaseEvent event) {
    switch (event.runtimeType) {
      case SignInEvent:
        handleSignIn(event);
        break;
    }
  }

  handleSignIn(event) {
    btnSink.add(false); //Khi bắt đầu call api thì disable nút sign-in
    loadingSink.add(true); // show loading

    Future.delayed(const Duration(seconds: 6), () {
      SignInEvent e = event as SignInEvent;
      _userRepo.signIn(e.email, e.pass).then(
        (userData) {
          processEventSink.add(SignInSuccessEvent(userData));
          print('đang in data');
        },
        onError: (e) {
          // ignore: avoid_print
          print(e);
          btnSink.add(true); //Khi có kết quả thì enable nút sign-in trở lại
          loadingSink.add(false); // hide loading
          processEventSink
              .add(SignInFailEvent(e.toString())); // thông báo kết quả
        },
      );
    });
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
    // ignore: avoid_print
    print("singin close");

    _emailSubject.close();
    _passSubject.close();
    _btnSubject.close();
    _userSubject.close();
  }
}
