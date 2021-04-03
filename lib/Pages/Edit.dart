import 'package:bookshelf/models/Book.dart';
import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {

  final Book book;
  EditPage(this.book);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
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
