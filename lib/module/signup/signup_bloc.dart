import 'dart:async';

import 'package:app_storethuc/base/base_event.dart';
import 'package:app_storethuc/base/base_bloc.dart';
import 'package:app_storethuc/data/repo/user_repo.dart';

import 'package:app_storethuc/event/signup_event.dart';
import 'package:app_storethuc/shared/validation.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

class SignUpBloc extends BaseBloc with ChangeNotifier {
  final _nameSubject = BehaviorSubject<String>();
  final _emailSubject = BehaviorSubject<String>();
  final _passSubject = BehaviorSubject<String>();
  final _btnSubject = BehaviorSubject<bool>();
  late UserRepo _userRepo;

  SignUpBloc({required UserRepo userRepo}) {
    _userRepo = userRepo;
    btnSink.add(true);
    validateForm();
  }
  var nameValidation =
      StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (Validation.isNameValid(name)) {
      sink.add('');
      return;
    }
    sink.add('Name invalid');
  });
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

  Stream<String> get nameStream =>
      _nameSubject.stream.transform(nameValidation);
  Sink<String> get nameSink => _nameSubject.sink;

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

  validateForm() {
    Rx.combineLatest2(
      emailStream,
      passStream,
      (email, pass) {
        return Validation.isEmailValid(email) && Validation.isPassValid(pass);
      },
    ).listen((enable) => btnSink.add(enable));
  }

  @override
  void dispatchEvent(BaseEvent event) {
    switch (event.runtimeType) {
      case SignUpEvent:
        handleSignUp(event);
        break;
    }
  }

  void handleSignUp(event) {
    SignUpEvent e = event as SignUpEvent;
    _userRepo.signUp(e.name, e.email, e.pass).then(
      (userData) {
        // ignore: avoid_print
        print(userData);
      },
      onError: (e) {
        // ignore: avoid_print
        print(e);
      },
    );
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
    _nameSubject.close();
    _emailSubject.close();
    _passSubject.close();
    _btnSubject.close();
  }
}
