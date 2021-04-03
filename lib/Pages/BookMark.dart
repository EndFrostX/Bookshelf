import 'package:flutter/material.dart';

class BookMarkPage extends StatefulWidget {
  @override
  _BookMarkPageState createState() => _BookMarkPageState();
}

class _BookMarkPageState extends State<BookMarkPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _myAppBar,
      body: _myBody,
    );
  }
  get _myAppBar{

  }
  get _myBody{
    return ListView(

    );
  }
}
