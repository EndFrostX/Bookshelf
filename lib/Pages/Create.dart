import 'package:bookshelf/models/BookCategory.dart';
import 'package:bookshelf/models/BookCategoryResponse.dart';
import 'package:bookshelf/repos/book_category_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class CreatePage extends StatefulWidget {
  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  double _width;
  Future<BookCategoryResponse> _fetchCategories;
  List<BookCategory> _allCategories;

  var _pdfController = TextEditingController();
  var _titleController = TextEditingController();
  var _authorController = TextEditingController();
  var _descriptionController = TextEditingController();
  int _categoryInput;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _fetchCategories = getAllBookCategories();
    });
  }

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

  get _futureBuilder {
    return FutureBuilder<BookCategoryResponse>(
      future: _fetchCategories,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          _allCategories = snapshot.data.data;
          return _contentCategory;
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  get _contentCategory {
    return Card(
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(27)),
        child: Column(
          children: [
            Text("There are ${_allCategories.length} :"),
            SearchableDropdown.single(
              items: _allCategories.map((BookCategory category) {
                return new DropdownMenuItem(
                  child: Text(category.name),
                  value: category.id,
                );
              }).toList(),
              isExpanded: true,
              searchHint: new Text("Select"),
              label: Text("Category"),
              onChanged: (value) {
                setState(() {
                  _categoryInput = value;
                  print(_categoryInput);
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
                keyboard: TextInputType.url, myController: _pdfController),
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
          ElevatedButton(
            child: Text("Upload"),
            onPressed: () {},
          )
        ],
      ),
    );
  }

  _textFieldStuff(String label, String hint,
      {TextInputType keyboard = TextInputType.text,
      TextCapitalization capitalization = TextCapitalization.none,
      TextEditingController myController,
      int min = 1,
      int max = 2}) {
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
                    borderSide: BorderSide(width: 1)),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
        ));
  }
}
