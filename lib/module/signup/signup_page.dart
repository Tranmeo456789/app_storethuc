import 'package:app_storethuc/data/remote/user_service.dart';
import 'package:app_storethuc/data/repo/user_repo.dart';
import 'package:app_storethuc/event/signup_event.dart';
import 'package:app_storethuc/module/signup/signup_bloc.dart';
import 'package:app_storethuc/shared/widget/normal_button.dart';
import 'package:flutter/material.dart';
import 'package:app_storethuc/shared/app_color.dart';
import 'package:provider/provider.dart';
import 'package:app_storethuc/base/base_widget.dart';
import 'package:app_storethuc/shared/fade_animation.dart';

enum FormData { name, phone, email, gender, password, confirmPassword }

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      title: 'Register',
      di: [
        Provider.value(
          value: UserService(),
        ),
        ProxyProvider<UserService, UserRepo>(
          update: (context, userService, previous) =>
              UserRepo(userService: userService),
        ),
      ],
      //bloc: [],
      child: const SignUpFormWidget(),
    );
  }
}

class SignUpFormWidget extends StatefulWidget {
  const SignUpFormWidget({super.key});

  @override
  State<SignUpFormWidget> createState() => _SignUpFormWidgetState();
}

class _SignUpFormWidgetState extends State<SignUpFormWidget> {
  Color enabled = const Color.fromARGB(255, 63, 56, 89);

  Color enabledtxt = Colors.white;

  Color deaible = Colors.grey;

  Color backgroundColor = const Color(0xFF1F1A30);

  bool ispasswordev = true;
  bool isConfirmPassword = true;
  FormData? selected;
  final TextEditingController _txtNameController = TextEditingController();
  final TextEditingController _txtPhoneController = TextEditingController();
  final TextEditingController _txtEmailController = TextEditingController();
  final TextEditingController _txtPassController = TextEditingController();
  final TextEditingController _txtConfirmPassController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Provider<SignUpBloc>.value(
      value: SignUpBloc(userRepo: Provider.of(context)),
      child: Consumer<SignUpBloc>(
        builder: (context, bloc, child) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FadeAnimation(
              delay: 0.8,
              child: Image.network(
                "https://cdni.iconscout.com/illustration/premium/thumb/job-starting-date-2537382-2146478.png",
                width: 100,
                height: 100,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const FadeAnimation(
              delay: 1,
              child: Text(
                "Create your account",
                style: TextStyle(color: Colors.white, letterSpacing: 0.5),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            _buildFullNameField(bloc),
            const SizedBox(
              height: 20,
            ),
            // _buildPhoneField(),
            // const SizedBox(
            //   height: 20,
            // ),
            _buildEmailField(bloc),
            const SizedBox(
              height: 20,
            ),
            _buildPassField(bloc),
            const SizedBox(
              height: 20,
            ),
            // _buildConfirmPassField(),
            // const SizedBox(
            //   height: 20,
            // ),
            _buildSignUpButton(bloc),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpButton(SignUpBloc bloc) {
    return StreamProvider<bool>.value(
      value: bloc.btnStream,
      initialData: false,
      child: Consumer<bool>(
        builder: (context, enable, child) => NormalButton(
          onPressed: enable
              ? () {
                  bloc.event.add(
                    SignUpEvent(
                      name: _txtNameController.text,
                      email: _txtEmailController.text,
                      pass: _txtPassController.text,
                    ),
                  );
                }
              : () {},
          title: 'Sign Up',
          enable: enable,
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/login');
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(top: 30),
          child: Text(
            'Đăng nhập',
            style: TextStyle(color: AppColor.blue, fontSize: 18),
          ),
        ),
      ),
    );
  }

  Widget _buildFullNameField(SignUpBloc bloc) {
    return StreamProvider<String>.value(
      value: bloc.nameStream,
      initialData: '',
      child: Consumer<String>(
        builder: (context, msg, child) => FadeAnimation(
          delay: 1,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: selected == FormData.name ? enabled : backgroundColor,
            ),
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              controller: _txtNameController,
              onTap: () {
                setState(() {
                  selected = FormData.name;
                });
              },
              onChanged: (text) {
                bloc.nameSink.add(text);
              },
              decoration: InputDecoration(
                enabledBorder: InputBorder.none,
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.title,
                  color: selected == FormData.name ? enabledtxt : deaible,
                  size: 30,
                ),
                hintText: 'Full Name',
                hintStyle: TextStyle(
                    color: selected == FormData.name ? enabledtxt : deaible,
                    fontSize: 22),
                errorText: (msg == '') ? null : msg,
              ),
              textAlignVertical: TextAlignVertical.center,
              style: TextStyle(
                  color: selected == FormData.name ? enabledtxt : deaible,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            ),
          ),
        ),
      ),
    );
  }

  // ignore: unused_element
  Widget _buildPhoneField() {
    return FadeAnimation(
      delay: 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: selected == FormData.phone ? enabled : backgroundColor,
        ),
        padding: const EdgeInsets.all(5.0),
        child: TextField(
          controller: _txtPhoneController,
          onTap: () {
            setState(() {
              selected = FormData.phone;
            });
          },
          decoration: InputDecoration(
            enabledBorder: InputBorder.none,
            border: InputBorder.none,
            prefixIcon: Icon(
              Icons.phone_android_rounded,
              color: selected == FormData.phone ? enabledtxt : deaible,
              size: 30,
            ),
            hintText: 'Phone Number',
            hintStyle: TextStyle(
                color: selected == FormData.phone ? enabledtxt : deaible,
                fontSize: 22),
          ),
          textAlignVertical: TextAlignVertical.center,
          style: TextStyle(
              color: selected == FormData.phone ? enabledtxt : deaible,
              fontWeight: FontWeight.bold,
              fontSize: 22),
        ),
      ),
    );
  }

  Widget _buildEmailField(SignUpBloc bloc) {
    return StreamProvider<String>.value(
      value: bloc.emailStream,
      initialData: '',
      child: Consumer<String>(
        builder: (context, msg, child) => FadeAnimation(
          delay: 1,
          child: Container(
            // width: 300,
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

  Widget _buildPassField(SignUpBloc bloc) {
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

  // ignore: unused_element
  Widget _buildConfirmPassField() {
    return FadeAnimation(
      delay: 1,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: selected == FormData.confirmPassword
                ? enabled
                : backgroundColor),
        padding: const EdgeInsets.all(5.0),
        child: TextField(
          controller: _txtConfirmPassController,
          onTap: () {
            setState(() {
              selected = FormData.confirmPassword;
            });
          },
          decoration: InputDecoration(
              enabledBorder: InputBorder.none,
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.lock_open_outlined,
                color:
                    selected == FormData.confirmPassword ? enabledtxt : deaible,
                size: 30,
              ),
              suffixIcon: IconButton(
                icon: isConfirmPassword
                    ? Icon(
                        Icons.visibility_off,
                        color: selected == FormData.confirmPassword
                            ? enabledtxt
                            : deaible,
                        size: 25,
                      )
                    : Icon(
                        Icons.visibility,
                        color: selected == FormData.confirmPassword
                            ? enabledtxt
                            : deaible,
                        size: 25,
                      ),
                onPressed: () =>
                    setState(() => isConfirmPassword = !isConfirmPassword),
              ),
              hintText: 'Confirm Password',
              hintStyle: TextStyle(
                  color: selected == FormData.confirmPassword
                      ? enabledtxt
                      : deaible,
                  fontSize: 22)),
          obscureText: isConfirmPassword,
          textAlignVertical: TextAlignVertical.center,
          style: TextStyle(
              color:
                  selected == FormData.confirmPassword ? enabledtxt : deaible,
              fontWeight: FontWeight.bold,
              fontSize: 22),
        ),
      ),
    );
  }
}
