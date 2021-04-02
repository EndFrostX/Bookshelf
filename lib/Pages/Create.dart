import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreatePage extends StatefulWidget {
  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  double _width;

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: _myAppBar,
      body: _myBody,
    );
  }

  get _myAppBar {
    return AppBar(
      title: Text("Upload Book"),
    );
  }

  get _myBody {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 26,
          ),
          Center(
            child: _myUrlTextField,
          ),
          SizedBox(
            height: 26,
          ),
          _infoTextField,
        ],
      ),
    );
  }

  get _myUrlTextField {
    return Container(
      width: _width * 0.90,
      child: TextField(
        decoration: InputDecoration(
          hintText: "PDF Url",
          hintStyle: TextStyle(
              fontSize: 15,
              color: Colors.grey.withOpacity(0.6),
              fontWeight: FontWeight.w600),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(27),
            borderSide: BorderSide(
              width: 4,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
        style: TextStyle(
          color: Colors.black.withOpacity(0.4),
          fontSize: 15,
        ),
        keyboardType: TextInputType.url,
        textCapitalization: TextCapitalization.words,
      ),
    );
  }

  get _infoTextField {
    return Container(
      width: _width * 0.90,
      child: TextField(
        decoration: InputDecoration(
          labelText: "PDF",
          hintText: "Enter your PDF Url",
          hintStyle: TextStyle(
              fontSize: 15,
              color: Colors.grey.withOpacity(0.6),
              fontWeight: FontWeight.w600),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(27),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
        style: TextStyle(
          color: Colors.black.withOpacity(0.4),
          fontSize: 15,
        ),
        keyboardType: TextInputType.url,
        textCapitalization: TextCapitalization.words,
      ),
    );
  }
}
