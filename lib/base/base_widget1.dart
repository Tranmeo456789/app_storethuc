import 'package:flutter/material.dart';
import 'package:app_storethuc/shared/app_color.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class PageContainer1 extends StatelessWidget {
  final String? title;
  final Widget? child;

  final List<SingleChildWidget>? bloc;
  final List<SingleChildWidget>? di;
  final List<Widget>? actions;

  const PageContainer1(
      {super.key, this.title, this.bloc, this.di, this.actions, this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ...di ?? [],
        ...bloc ?? [],
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.yellow,
          title: Text(
            title ?? '',
          ),
          actions: actions,
        ),
        body: child,
      ),
    );
  }
}

class NavigatorProvider extends StatelessWidget {
  const NavigatorProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
      child: Stack(
        children: const <Widget>[],
      ),
    );
  }
}
