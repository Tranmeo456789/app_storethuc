import 'package:flutter/material.dart';
import 'package:app_storethuc/shared/app_color.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class PageContainer extends StatelessWidget {
  final String title;
  final Widget? child;

  final List<SingleChildWidget>? bloc;
  final List<SingleChildWidget>? di;
  final List<Widget>? actions;

  const PageContainer(
      {super.key,
      required this.title,
      this.bloc,
      this.di,
      this.actions,
      this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          title,
          style: TextStyle(color: AppColor.white),
        ),
        actions: actions,
      ),
      body: Container(
        // padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          // gradient: LinearGradient(
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          //   stops: const [0.1, 0.4, 0.7, 0.9],
          //   colors: [
          //     HexColor("#4b4293").withOpacity(0.8),
          //     HexColor("#4b4293"),
          //     HexColor("#08418e"),
          //     HexColor("#08418e")
          //   ],
          // ),
          image: DecorationImage(
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                HexColor("#fff").withOpacity(0.2), BlendMode.dstATop),
            image: const AssetImage('assets/images/bg_login.png'),
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  //width: 400,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: MultiProvider(
                    providers: [
                      ...di ?? [],
                      ...bloc ?? [],
                    ],
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NavigatorProvider extends StatelessWidget {
  const NavigatorProvider({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Container(
      child: Stack(
        children: const <Widget>[],
      ),
    );
  }
}
