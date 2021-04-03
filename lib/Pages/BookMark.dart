import 'package:bookshelf/models/Book.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'Detail.dart';
import 'Edit.dart';

class BookMarkPage extends StatefulWidget {

  var bookMark = Set<Book>();
  BookMarkPage({this.bookMark});

  @override
  _BookMarkPageState createState() => _BookMarkPageState();
}

class _BookMarkPageState extends State<BookMarkPage> {

  double _width;
  double _height;
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  void _message(String text, Color color){
    ScaffoldMessenger.of(_scaffoldKey.currentContext).showSnackBar(SnackBar(content: Text(text), backgroundColor: color,));
  }
  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      appBar: _myAppBar,
      body: _myBody,
    );
  }
  get _myAppBar{
    return AppBar(
      title: Text("hi"),
    );
  }
  get _myBody {
    return ListView.builder(
        itemCount: widget.bookMark.length,
        itemBuilder: (context, index) {
          return _buildList(widget.bookMark.elementAt(index));
        });
  }

  _buildList(Book book) {
    return Container(
      width: _width,
      child: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
          _myContainerList(book),
        ],
      ),
    );
  }

  _myContainerList(Book book) {
    return InkWell(
      child: Container(
        height: _height * 0.2,
        width: _width,
        margin: EdgeInsets.zero,
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _containerPicture(book.pdfUrl, book),
            _containerText(title: book.title,
                author: book.author,
                description: book.description,
                published: book.published),
            _containerIcon(book),
          ],
        ),
      ),
      onTap: (){
        Navigator.of(context).push(PageTransition(child: DetailPage(book), type: PageTransitionType.rightToLeftWithFade));
      },
      onLongPress: (){
        _showDialogue(book);
      },
    );
  }

  _containerPicture(String img, Book book) {
    return InkWell(
      child: Card(
        elevation: 10,
        child: Container(
          width: _width * 0.35,
          height: _height * 0.3,
          decoration: BoxDecoration(
            color: Colors.red,
            boxShadow: [
              BoxShadow(
                color: Colors.blueAccent.withOpacity(0.2),
                blurRadius: 12,
              ),
            ],
            image: DecorationImage(
              image: NetworkImage(img),
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
      ),
      onTap: (){
        Navigator.of(context).push(PageTransition(
          child: DetailPage(book),
          type: PageTransitionType.rightToLeftWithFade,
        ));
      },
      onLongPress: (){
        _showDialogue(book);
      },
    );
  }

  _containerText(
      {String title,
        String author,
        String description,
        String published}) {
    return Container(
      padding: EdgeInsets.only(left: 10),
      width: _width * 0.45,
      height: _height * 0.3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Title: $title"),
          Text("Author: $author"),
          Text("Published Date: $published"),
          Text(description),
        ],
      ),
    );
  }

  _containerIcon(Book book) {
    bool _bookmark = false;
    return InkWell(
      child: Expanded(
        child: Container(
          alignment: Alignment.center,
          child: _bookmark ?
          Icon(Icons.bookmark, color: Colors.amber,) :
          Icon(Icons.check, color: Colors.lightGreen,),
        ),
      ),
      onTap: (){
        _message("Added to bookmark", Colors.lightGreen);
        _bookmark = !_bookmark;
      },
    );
  }

  _showDialogue(Book book) {
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text("Option"),
        backgroundColor: Colors.white,
        actions: [
          ElevatedButton(child: Text("Cancel"), onPressed: () {
            Navigator.of(context).pop();
          })
        ],
        content: Container(
          height: 150,
          width: 250,
          child: Column(
            children: [
              _contentDialogue("Edit", Icons.edit, function: (){
                Navigator.of(context).push(PageTransition(child: EditPage(book), type: PageTransitionType.rightToLeftWithFade));
                Navigator.of(context).pop();
              }),
              _contentDialogue("Delete", Icons.delete, function: (){

                _message("Deleted", Colors.redAccent);
                setState(() {

                });
                Navigator.of(context).pop();
              }),
            ],
          ),
        ),
      );
    });
  }

  _contentDialogue(String text, IconData icon, {Function function}) {
    return InkWell(
      child: Center(
        child: Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(text),
              Expanded(child: Icon(icon)),
            ],
          ),
        ),
      ),
      //onTap: onTap,
      onTap: function,
    );
  }
}
