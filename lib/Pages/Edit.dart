import 'package:bookshelf/Pages/Category.dart';
import 'package:bookshelf/models/Book.dart';
import 'package:bookshelf/models/BookCategory.dart';
import 'package:bookshelf/models/BookCategoryResponse.dart';
import 'package:bookshelf/repos/book_category_repo.dart';
import 'package:bookshelf/repos/book_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class EditPage extends StatefulWidget {
  EditPage(this.book);

  final Book book;

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
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
  var _tempHolderOfCategory = TextEditingController();
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _fetchCategories = getAllBookCategories();
      _pdfController.text = widget.book.pdfUrl;
      _titleController.text = widget.book.title;
      _authorController.text = widget.book.author;
      _publishedController.text = widget.book.published;
      _pagesController.text = widget.book.pages.toString();
      _descriptionController.text = widget.book.description;
      _tempHolderOfCategory.text = widget.book.category.name;
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
      title: Text("Edit Book"),
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
          _textFieldStuff(
            "Title",
            "Enter the book title",
            capitalization: TextCapitalization.words,
            myController: _titleController,
            disable: false,
          ),
          _textFieldStuff("Author", "Enter Author name",
              capitalization: TextCapitalization.words,
              myController: _authorController),
          _textFieldStuff(
            "Description",
            "Enter the description",
            capitalization: TextCapitalization.sentences,
            myController: _descriptionController,
            max: 10,
            disable: false,
          ),
          _textFieldStuff("Published", "Enter the published Date",
              capitalization: TextCapitalization.none,
              myController: _publishedController,
              keyboard: TextInputType.numberWithOptions()),
          _textFieldStuff("Pages", "Enter the total pages of the PDF",
              capitalization: TextCapitalization.none,
              myController: _pagesController,
              keyboard: TextInputType.numberWithOptions()),
          _textFieldStuff(
            "Category",
            "Choose your category...",
            myController: _tempHolderOfCategory,
          ),
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
              child: Text("Update"),
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
    if (_titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty) {

      setState(() {
        _loading = true;
      });

      Book book = Book(
        id: widget.book.id,
        title: _titleController.text.trim(),
        author: widget.book.author,
        description: _descriptionController.text.trim(),
        pdfUrl: widget.book.pdfUrl,
        categoryId: widget.book.categoryId,
        published: widget.book.published,
        pages: widget.book.pages,
        views: widget.book.views
      );


      updateBook(book).then((value) {
        if (!value.error) {
          _message(value.message, Colors.lightGreen);
          Navigator.of(context).pop(book);
        } else {
          setState(() {
            _loading = false;
          });
          _message(value.message, Colors.redAccent);
        }
      });
    } else {
      _message(
          "Please fill all the fields before proceeding", Colors.redAccent);
    }
  }

  _textFieldStuff(
    String label,
    String hint, {
    TextInputType keyboard = TextInputType.text,
    TextCapitalization capitalization = TextCapitalization.none,
    TextEditingController myController,
    int min = 1,
    int max = 2,
    bool disable = true,
  }) {
    return Container(
        width: _width * 0.80,
        child: Column(
          children: [
            TextField(
              enabled: !disable,
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
                color: disable ? Colors.grey : Colors.black,
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
