import 'package:flutter/material.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _myAppBar,
      body: _myBody,
    );
  }
  get _myAppBar{
    return AppBar();
  }
  get _myBody{
    return Container();
  }
}
