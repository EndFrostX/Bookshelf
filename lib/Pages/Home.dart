import 'dart:ui';

import 'package:bookshelf/Class/BookMarkPreferences.dart';
import 'package:bookshelf/Pages/BookMark.dart';
import 'package:bookshelf/Pages/Category.dart';
import 'package:bookshelf/models/Book.dart';
import 'package:bookshelf/models/BookResponse.dart';
import 'package:bookshelf/repos/book_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Create.dart';
import 'Detail.dart';
import 'Edit.dart';
import 'PrivacyPolicy.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double _width;
  double _height;
  Future<BookResponse> _futureData;
  List<Book> _data = [];
  List<String> _saved = [];
  List<String> ree = [];
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  void _message(String text, Color color) {
    ScaffoldMessenger.of(_scaffoldKey.currentContext).showSnackBar(SnackBar(
      content: Text(text),
      backgroundColor: color,
    ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _saved = BookMarkPreferences.getBookID() ?? [];
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      body: _myBody,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (_) => CreatePage(),
            ),
          )
              .then((value) {
            if (value != null) {
              refresh();
            }
          });
        },
        child: Container(
          child: Icon(
            Icons.upload_rounded,
          ),
        ),
      ),
    );
  }

  get _myBody {
    return FutureBuilder<BookResponse>(
      future: _futureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          _data = snapshot.data.data;
          if (_data.isEmpty) {
            return Center(
              child: Container(
                width: _width * 0.8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: _width,
                      height: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage("https://cdni.iconscout.com/illustration/premium/thumb/empty-mind-3428245-2902710.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Text(
                      "It seems there's no uploaded book right now please come back another time",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).primaryColor),
                      ),
                      icon: Icon(Icons.refresh),
                      label: Text("Refresh"),
                      onPressed: () {
                        refresh();
                      },
                    ),
                  ],
                ),
              ),
            );
          } else {
            return _myListView;
          }
        } else {
          return Center(child: RefreshProgressIndicator());
        }
      },
    );
  }

  get _myListView {
    return RefreshIndicator(
      child: ListView.builder(
        itemCount: _data.length,
        itemBuilder: (context, index) {
          if (index < _data.length - 1) {
            return Column(
              children: [
                _myContainerList(_data[index]),
                Divider(),
              ],
            );
          }
          return _myContainerList(_data[index]);
        },
      ),
      onRefresh: () {
        setState(() {
          _futureData = getAllBooks();
        });
        return _futureData;
      },
    );
  }

  _myContainerList(Book book) {
    return InkWell(
      child: Container(
        height: _height * 0.3,
        width: _width,
        margin: EdgeInsets.zero,
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _containerPicture(book),
            _containerText(book),

            Expanded(child: _containerIcon(book)),
          ],
        ),
      ),
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(
          builder: (_) => DetailPage(book),
        ))
            .then((value) {
          refresh();
        });
      },
      onLongPress: () {
        _showDialogue(book);
      },
    );
  }

  _containerPicture(Book book) {
    return InkWell(
      child: Card(
        elevation: 10,
        child: Container(
          width: _width * 0.35,
          height: _height * 0.3,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            boxShadow: [
              BoxShadow(
                color: Colors.blueAccent.withOpacity(0.2),
                blurRadius: 12,
              ),
            ],
            image: DecorationImage(
              image: NetworkImage(
                  "https://i.pinimg.com/originals/dd/64/da/dd64da585bc57cb05e5fd4d8ce873f57.png"),
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
      ),
      onTap: () {
        Navigator.of(context)
            .push(PageTransition(
          child: DetailPage(book),
          type: PageTransitionType.rightToLeftWithFade,
        ))
            .then((value) {
          refresh();
        });
      },
      onLongPress: () {
        _showDialogue(book);
      },
    );
  }

  _containerText(Book book) {
    return Container(
      padding: EdgeInsets.only(left: 10, top: 3, bottom: 3),
      width: _width * 0.45,
      height: _height * 0.35,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            book.title,
            style: TextStyle(
              fontSize: 17,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "category: ",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    book.category.name,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).primaryColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                book.description,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.remove_red_eye,
                size: 17,
              ),
              Text(
                _viewCalculator(book.views),
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).primaryColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  _containerIcon(Book book) {
    bool bookmark = _saved.contains(book.id.toString());
    //bool bookmark = false;
    return InkWell(
      child: Container(
        alignment: Alignment.center,
        child: bookmark ? Icon(Icons.check, color: Colors.lightGreen,)
            : Icon(Icons.bookmark, color: Colors.amber,)
      ),
      onTap: () async{
        //if false do this
        if(!bookmark){
          setState(() {
            _saved.add(book.id.toString());
          });
          await BookMarkPreferences.setBookID(_saved);
          _message("Added to bookmark", Colors.lightGreen);

        }
        else{
          setState((){
            _saved.remove(book.id.toString());
          });
          await BookMarkPreferences.setBookID(_saved);
          _message("Remove from bookmark", Colors.lightGreen);
        }
        print(_saved);
      },
    );
  }

  _showDialogue(Book book) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Options",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Theme.of(context).primaryColor,
            actions: [
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.grey),
                  ),
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ],
            content: Container(
              height: 150,
              width: 250,
              child: Column(
                children: [
                  _contentDialogue("Edit", Icons.edit, function: () {
                    Navigator.of(context).pop();
                    Navigator.of(context)
                        .push(
                      MaterialPageRoute(
                        builder: (_) => EditPage(book),
                      ),
                    )
                        .then((value) {
                      refresh();
                    });
                  }),
                  _contentDialogue("Delete", Icons.delete, function: () {
                    Navigator.of(context).pop();
                    deleteBook(book).then((value) {
                      setState(() {
                        _data.removeWhere((e) => e.id == book.id);
                      });
                      _message("Deleted", Colors.redAccent);
                    });
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
          padding: EdgeInsets.all(15),
          margin: EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Icon(
                icon,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
      ),
      //onTap: onTap,
      onTap: function,
    );
  }

  void refresh() {
    setState(() {
      _futureData = getAllBooks();
    });
  }

  String _viewCalculator(int views) {
    if (views >= 1000) {
      double calView = views / 1000;
      return " ${calView.toStringAsFixed(2)}k";
    } else {
      return " ${views}";
    }
  }
}
