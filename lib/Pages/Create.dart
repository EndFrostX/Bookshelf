import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class CreatePage extends StatefulWidget {
  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  double _width;

  var _pdfController = TextEditingController();
  var _titleController = TextEditingController();
  var _authorController = TextEditingController();
  var _descriptionController = TextEditingController();
  var _categoryController = TextEditingController();

  Map<String, Widget> _widgets;

  @override
  Widget build(BuildContext context) {
    _widgets = {
      "Single dialog": SearchableDropdown.single(
        items: items,
        value: selectedValue,
        hint: "Select one",
        searchHint: "Select one",
        onChanged: (value) {
          setState(() {
            selectedValue = value;
          });
        },
        isExpanded: true,
      ),
    }
    _width = MediaQuery
        .of(context)
        .size
        .width;
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
            child: _textFieldStuff("PDF", "Enter the PDF Url",
                keyboard: TextInputType.url,
                myController: _pdfController),
          ),
          _textFieldStuff("Title", "Enter the book title",
              capitalization: TextCapitalization.words,
              myController: _titleController),

          _textFieldStuff("Author", "Enter Author name",
              capitalization: TextCapitalization.words,
              myController: _authorController),

          _textFieldStuff("Description", "Enter the description",
              capitalization: TextCapitalization.sentences,
              myController: _descriptionController),

          _textFieldStuff("Category", "Enter the description",
              capitalization: TextCapitalization.sentences,
              myController: _categoryController),
        ],
      ),
    );
  }

  _textFieldStuff(String label, String hint,
       {TextInputType keyboard = TextInputType.text,
        TextCapitalization capitalization = TextCapitalization.none,
        TextEditingController myController}) {
    return Container(
      width: _width * 0.90,
      child: Column(
        children: [
          TextField(
            controller: myController,
            decoration: InputDecoration(
              labelText: label,
              hintText: hint,
              hintStyle: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.withOpacity(0.6),
                  fontWeight: FontWeight.w600),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(27),
                  borderSide: BorderSide(
                    width: 1
                  )
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
            style: TextStyle(
              color: Colors.black.withOpacity(0.4),
              fontSize: 15,
            ),
            keyboardType: keyboard,
            textCapitalization: capitalization,
          ),
          SizedBox(
            height: 26,
          ),
        ],
      ),
    );
  }
}