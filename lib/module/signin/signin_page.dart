import 'package:app_storethuc/shared/fade_animation.dart';
import 'package:flutter/material.dart';
import 'package:app_storethuc/base/base_event.dart';
import 'package:app_storethuc/base/base_widget.dart';
import 'package:app_storethuc/data/remote/user_service.dart';
import 'package:app_storethuc/data/repo/user_repo.dart';
import 'package:app_storethuc/event/signin_fail_event.dart';
import 'package:app_storethuc/event/signin_sucess_event.dart';
import 'package:app_storethuc/event/singin_event.dart';
import 'package:app_storethuc/module/signin/signin_bloc.dart';
import 'package:app_storethuc/shared/app_color.dart';
import 'package:app_storethuc/shared/widget/bloc_listener.dart';
import 'package:app_storethuc/shared/widget/loading_task.dart';
import 'package:app_storethuc/shared/widget/normal_button.dart';
import 'package:provider/provider.dart';

enum FormData {
  email,
  password,
}

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      title: 'Sign In',
      di: [
        Provider.value(
          value: UserService(),
        ),
        ProxyProvider<UserService, UserRepo>(
          update: (context, userService, previous) =>
              UserRepo(userService: userService),
        ),
      ],
      bloc: const [],
      child: const SignInFormWidget(),
    );
  }
}

class SignInFormWidget extends StatefulWidget {
  const SignInFormWidget({super.key});

  @override
  State<SignInFormWidget> createState() => _SignInFormWidgetState();
}

class _SignInFormWidgetState extends State<SignInFormWidget> {
  Color enabled = const Color.fromARGB(255, 63, 56, 89);
  Color enabledtxt = Colors.white;
  Color deaible = Colors.grey;
  Color backgroundColor = const Color(0xFF1F1A30);
  bool ispasswordev = true;
  FormData? selected;

  final TextEditingController _txtEmailController = TextEditingController();
  final TextEditingController _txtPassController = TextEditingController();

  handleEvent(BaseEvent event) {
    if (event is SignInSuccessEvent) {
      Navigator.pushReplacementNamed(context, '/home');
      return;
    }

    if (event is SignInFailEvent) {
      final snackBar = SnackBar(
        content: Text(event.errMessage),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignInBloc(userRepo: Provider.of(context)),
      child: Consumer<SignInBloc>(
        builder: (context, bloc, child) {
          return BlocListener<SignInBloc>(
            listener: handleEvent,
            child: LoadingTask(
              bloc: bloc,
              child: Container(
                padding: const EdgeInsets.all(5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.network(
                      "https://cdni.iconscout.com/illustration/premium/thumb/job-starting-date-2537382-2146478.png",
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const FadeAnimation(
                      delay: 1,
                      child: Text(
                        "Please sign in to continue",
                        style: TextStyle(
                            color: Color.fromARGB(255, 109, 88, 88),
                            letterSpacing: 0.5),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    _buildEmailField(bloc),
                    const SizedBox(
                      height: 20,
                    ),
                    _buildPassField(bloc),
                    const SizedBox(
                      height: 20,
                    ),
                    _buildSignInButton(bloc),
                    _buildFooter(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSignInButton(SignInBloc bloc) {
    return StreamProvider<bool>.value(
      value: bloc.btnStream,
      initialData: false,
      child: Consumer<bool>(
        builder: (context, enable, child) => NormalButton(
          onPressed: enable
              ? () {
                  bloc.event.add(
                    SignInEvent(
                        email: _txtEmailController.text,
                        pass: _txtPassController.text),
                  );
                }
              : () {},
          title: 'Login',
          enable: enable,
        ),
      ),
    );
  }

  // Widget _buildLogibButton(SignInBloc bloc) {
  //   return StreamBuilder(
  //       stream: bloc.btnStream,
  //       builder: ((context, snapShot) => NormalButton(
  //             onPressed: snapShot.hasData
  //                 ? () {
  //                     // bloc.event.add(
  //                     //   SignInEvent(
  //                     //       email: _txtEmailController.text,
  //                     //       pass: _txtPassController.text),
  //                     // );
  //                   }
  //                 : () {},
  //             title: 'Login',
  //             enable: snapShot.hasData,
  //           )));
  // }

  Widget _buildFooter() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/register');
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(top: 30),
          child: Text(
            'Đăng ký tài khoản',
            style: TextStyle(color: AppColor.blue, fontSize: 18),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField(SignInBloc bloc) {
    return StreamProvider<String>.value(
      value: bloc.emailStream,
      initialData: '',
      child: Consumer<String>(
        builder: (context, msg, child) => FadeAnimation(
          delay: 1,
          child: Container(
            //width: 300,
            //height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: selected == FormData.email ? enabled : backgroundColor,
            ),
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              controller: _txtEmailController,
              onTap: () {
                setState(() {
                  selected = FormData.email;
                });
              },
              onChanged: (text) {
                bloc.emailSink.add(text);
              },
              decoration: InputDecoration(
                enabledBorder: InputBorder.none,
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: selected == FormData.email ? enabledtxt : deaible,
                  size: 30,
                ),
                hintText: 'Email',
                hintStyle: TextStyle(
                    color: selected == FormData.email ? enabledtxt : deaible,
                    fontSize: 22),
                errorText: (msg == '') ? null : msg,
              ),
              textAlignVertical: TextAlignVertical.center,
              style: TextStyle(
                  color: selected == FormData.email ? enabledtxt : deaible,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPassField(SignInBloc bloc) {
    return StreamProvider<String>.value(
      value: bloc.passStream,
      initialData: '',
      child: Consumer<String>(
        builder: (context, msg, child) => FadeAnimation(
          delay: 1,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color:
                    selected == FormData.password ? enabled : backgroundColor),
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              controller: _txtPassController,
              onTap: () {
                setState(() {
                  selected = FormData.password;
                });
              },
              onChanged: (text) {
                bloc.passSink.add(text);
              },
              decoration: InputDecoration(
                enabledBorder: InputBorder.none,
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.lock_open_outlined,
                  color: selected == FormData.password ? enabledtxt : deaible,
                  size: 30,
                ),
                suffixIcon: IconButton(
                  icon: ispasswordev
                      ? Icon(
                          Icons.visibility_off,
                          color: selected == FormData.password
                              ? enabledtxt
                              : deaible,
                          size: 25,
                        )
                      : Icon(
                          Icons.visibility,
                          color: selected == FormData.password
                              ? enabledtxt
                              : deaible,
                          size: 25,
                        ),
                  onPressed: () => setState(() => ispasswordev = !ispasswordev),
                ),
                hintText: 'Password',
                hintStyle: TextStyle(
                    color: selected == FormData.password ? enabledtxt : deaible,
                    fontSize: 22),
                errorText: (msg == '') ? null : msg,
              ),
              obscureText: ispasswordev,
              keyboardType: TextInputType.text,
              textAlignVertical: TextAlignVertical.center,
              style: TextStyle(
                  color: selected == FormData.password ? enabledtxt : deaible,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            ),
          ),
        ),
      ),
    );
  }
}
