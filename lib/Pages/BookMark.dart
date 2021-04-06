import 'package:bookshelf/Class/BookMarkPreferences.dart';
import 'package:bookshelf/models/Book.dart';
import 'package:bookshelf/models/BookResponse.dart';
import 'package:bookshelf/repos/book_repo.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../models/BookResponse.dart';
import 'Detail.dart';
import 'Edit.dart';

class BookMarkPage extends StatefulWidget {
  @override
  _BookMarkPageState createState() => _BookMarkPageState();
}

class _BookMarkPageState extends State<BookMarkPage> {
  double _width;
  double _height;
  List<String> _id = [];
  Future<BookResponse> _futureData;
  List<Book> _data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _id = BookMarkPreferences.getBookID() ?? [];
    _futureData = getAllBooks();
  }

  var _scaffoldKey = GlobalKey<ScaffoldState>();

  void _message(String text, Color color) {
    ScaffoldMessenger.of(_scaffoldKey.currentContext).showSnackBar(SnackBar(
      content: Text(text),
      backgroundColor: color,
    ));
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      body: _futureBuilder,
    );
  }

  get _futureBuilder {
    if (_id.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: _width,
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("asset/images/empty.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              child: Text(
                "You haven't bookmark anything yet.",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
          ],
        ),
      );
    } else {
      return FutureBuilder<BookResponse>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            _data = snapshot.data.data;
            if (_data.isNotEmpty) {
              return _myBody;
            } else {
              return Center(
                child: Column(
                  children: [
                    Container(
                      width: _width,
                      height: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("asset/images/empty.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        "You haven't bookmark anything yet.",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              );
            }
          } else {
            return Center(child: RefreshProgressIndicator());
          }
        },
      );
    }
  }

  get _myBody {
    return ListView.builder(
      itemCount: _data.length,
      itemBuilder: (context, index) {
        if (_id.contains(_data[index].id.toString())) {
          if (index < _data.length - 1) {
            return Column(
              children: [
                _myContainerList(_data[index]),
                Divider(),
              ],
            );
          }
          return _myContainerList(_data[index]);
        } else {
          return SizedBox();
        }
      },
    );
  }

  _myContainerList(Book book) {
    return InkWell(
      child: Container(
        height: 150,
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
          if (value[0] == "delete") {
            setState(() {
              _id.remove(value[1].toString());
            });
            BookMarkPreferences.setBookID(_id);
            _message("Remove from bookmark", Colors.lightGreen);
          }
        });
      },
      onLongPress: () {
        _showDialogue(book);
      },
    );
  }

  _containerPicture(Book book) {
    return Card(
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
            image: AssetImage("asset/images/logo.png"),
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
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
    bool bookmark = _id.contains(book.id.toString());
    //bool bookmark = false;
    return InkWell(
      child: Container(
          alignment: Alignment.center,
          child: bookmark
              ? Icon(
                  Icons.check,
                  color: Colors.lightGreen,
                )
              : Icon(
                  Icons.bookmark,
                  color: Colors.amber,
                )),
      onTap: () async {
        //if false do this
        if (!bookmark) {
          setState(() {
            _id.add(book.id.toString());
          });
          await BookMarkPreferences.setBookID(_id);
          _message("Added to bookmark", Colors.lightGreen);
        } else {
          setState(() {
            _id.remove(book.id.toString());
          });
          await BookMarkPreferences.setBookID(_id);
          _message("Remove from bookmark", Colors.lightGreen);
        }
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
                  _contentDialogue("Removed", Icons.delete, function: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _id.remove(book.id.toString());
                    });
                    BookMarkPreferences.setBookID(_id).then((value) {
                      _message("Successfully removed from bookmark",
                          Colors.lightGreen);
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
