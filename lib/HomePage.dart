import 'package:flutter/material.dart';
import 'HomeTab.dart';
import 'CustomDrawer.dart';
import 'ProductsTab.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(
          body: HomeTab(),
          drawer: CustomDrawer(this._pageController),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Products"),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageController),
          body: ProductsTab(),
        ),
      ],
    );
  }
}
