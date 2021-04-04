import 'package:bookshelf/models/Book.dart';
import 'package:bookshelf/models/BookCategory.dart';
import 'package:bookshelf/models/BookCategoryResponse.dart';
import 'package:bookshelf/repos/book_category_repo.dart';
import 'package:bookshelf/repos/book_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class CreatePage extends StatefulWidget {
  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  bool _loading = false;
  double _width;
  Future<BookCategoryResponse> _fetchCategories;
  List<BookCategory> _allCategories;

  var _pdfController = TextEditingController();
  var _titleController = TextEditingController();
  var _authorController = TextEditingController();
  var _publishedController = TextEditingController();
  var _pagesController = TextEditingController();
  var _descriptionController = TextEditingController();
  BookCategory _tempHolderOfCategory;
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _fetchCategories = getAllBookCategories();
    });
  }

  void _message(String text, Color color) {
    ScaffoldMessenger.of(_scaffoldKey.currentContext).showSnackBar(SnackBar(
      content: Text(text),
      backgroundColor: color,
    ));
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      appBar: _myAppBar,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: _myBody,
      ),
    );
  }

  get _myAppBar {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
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
          return Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Loading category "),
                RefreshProgressIndicator(),
              ],
            ),
          );
        }
      },
    );
  }

  get _contentCategory {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      margin: EdgeInsets.only(bottom: 20),
      width: _width * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(27),
        border: Border.all(
          color: Colors.grey,
        ),
      ),
      child: SearchableDropdown.single(
        items: _allCategories.map((BookCategory category) {
          return new DropdownMenuItem(
            child: Text(category.name),
            value: category,
          );
        }).toList(),
        isExpanded: true,
        searchHint: new Text("search category"),
        hint: "Choose your category",
        onChanged: (BookCategory value) {
          setState(() {
            _tempHolderOfCategory = value;
          });
        },
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
          _textFieldStuff("Published", "Enter the published Date",
              capitalization: TextCapitalization.none,
              myController: _publishedController,
              keyboard: TextInputType.numberWithOptions()),
          _textFieldStuff("Pages", "Enter the total pages of the PDF",
              capitalization: TextCapitalization.none,
              myController: _pagesController,
              keyboard: TextInputType.numberWithOptions()),
          _futureBuilder,
          _loading
              ? Container(
                  child: RefreshProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                  ),
                )
              : Container(
                  width: _width / 1.3,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).primaryColor),
                    ),
                    child: Text("Upload"),
                    onPressed: () {
                      _auth();
                    },
                  ),
                ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  _auth() {
    if (_pdfController.text.trim().isNotEmpty &&
        _titleController.text.trim().isNotEmpty &&
        _authorController.text.trim().isNotEmpty &&
        _descriptionController.text.trim().isNotEmpty &&
        _tempHolderOfCategory != null) {
      setState(() {
        _loading = true;
      });
      Book book = Book(
        title: _titleController.text.trim(),
        author: _authorController.text.trim(),
        description: _descriptionController.text.trim(),
        pdfUrl: _pdfController.text.trim(),
        categoryId: _tempHolderOfCategory.id,
        published: _publishedController.text.trim(),
        pages: int.parse(_pagesController.text.trim()),
      );

      insertBook(book).then((value) {
        if (!value.error) {
          _message(value.message, Colors.lightGreen);
          Navigator.of(context).pop(true);
        } else {
          setState(() {
            _loading = false;
          });
          _message(value.message, Colors.redAccent);
        }
      });
    } else {
      setState(() {
        _loading = false;
      });
      _message(
          "Please fill all the fields before proceeding", Colors.redAccent);
    }
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
              color: Colors.black,
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
