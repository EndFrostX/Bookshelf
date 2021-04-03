import 'package:bookshelf/Models/BookCategory.dart';
import 'package:bookshelf/Repos/book_category_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class CreatePage extends StatefulWidget {
  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  double _width;
  List<BookCategory> _data;
  var _pdfController = TextEditingController();
  var _titleController = TextEditingController();
  var _authorController = TextEditingController();
  var _descriptionController = TextEditingController();
  var _categoryController;


  @override
  Widget build(BuildContext context) {
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
  get _futureBuilder{
    return FutureBuilder(
        future: getAllBookCategories(),
        builder: (context, snapshot){
      if(snapshot.connectionState == ConnectionState.done){
        _data = snapshot.data.data;
        return _contentCategory();
      }
      else{
        return CircularProgressIndicator();
      }
    });
  }
  _contentCategory(){
    return Card(
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(27)),
        child: Column(
          children: [
            Text("Enter"),
            SearchableDropdown.single(
              items: _data.map((category){
                return new DropdownMenuItem(child: Text(category.name), value: category.name,);
              }).toList(),
              isExpanded: true,
              value: _categoryController,
              searchHint: new Text("Select"),
              label: Text("Category"),
              onChanged: (value){
                setState(() {
                  _categoryController = value;
                  print(_categoryController);
                });
              },
            ),
          ],
        ),
      ),
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
              myController: _descriptionController,
              max: 10),
          _futureBuilder,
          // _futureBuilder,
          ElevatedButton(child: Text("Upload"), onPressed: (){
          },)
        ],
      ),
    );
  }

  _textFieldStuff(String label, String hint,
       {TextInputType keyboard = TextInputType.text,
        TextCapitalization capitalization = TextCapitalization.none,
        TextEditingController myController,int min=1, int max=2}) {
    return Container(
      width: _width * 0.80,
      child: Column(
        children: [
          TextField(
            controller: myController,
            maxLines: max,
            minLines: min,
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
        ],));
  }
}
