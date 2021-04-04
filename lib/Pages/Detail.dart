import 'package:bookshelf/Pages/Edit.dart';
import 'package:bookshelf/models/Book.dart';
import 'package:bookshelf/repos/book_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Category.dart';

class DetailPage extends StatefulWidget {
  final Book book;

  DetailPage(this.book);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _myAppBar,
      body: _myBody,
    );
  }

  get _readButton {
    return Container(
      child: ElevatedButton.icon(
        icon: Icon(Icons.open_in_new_rounded),
        label: Text("Read Book"),
        onPressed: () {
          _launchURL();
        },
      ),
    );
  }

  get _myAppBar {
    return AppBar(
      title: Text(widget.book.title),
      actions: [
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            Navigator.of(context).push(
              PageTransition(
                child: EditPage(widget.book),
                type: PageTransitionType.bottomToTop,
              ),
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.delete),
          color: Colors.red[500],
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) {
                return Dialog(
                  backgroundColor: Colors.white.withOpacity(0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    height: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Are you sure !",
                                style: TextStyle(
                                  fontSize: 23,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "You will not be able to see this book after you delete!",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.grey,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: Icon(Icons.cancel),
                                  label: Text("Cancel"),
                                ),
                              ),
                              Container(
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.red,
                                  ),
                                  onPressed: () {
                                    deleteBook(widget.book);
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                  icon: Icon(Icons.delete),
                                  label: Text("Yes"),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  get _myBody {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.book.title,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  "author: ",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  "${widget.book.author}",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "category: ",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  "${widget.book.category.name}",
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "published ",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  "${widget.book.published}",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              widget.book.description,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "pages: ",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "${widget.book.pages}",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  VerticalDivider(
                    color: Colors.white,
                    width: 1,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          "views: ",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "${widget.book.views}",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(vertical: 20),
              child: _readButton,
            ),
          ],
        ),
      ),
    );
  }

  get _bookCoverPDF {
    return Center(
      child: Card(
          elevation: 12,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.60,
            height: 200,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: NetworkImage(
                  "https://149349728.v2.pressablecdn.com/wp-content/uploads/2019/08/The-Crying-Book-by-Heather-Christie-1.jpg"),
              fit: BoxFit.cover,
            )),
          )),
    );
  }

  void _launchURL() async => await canLaunch(widget.book.pdfUrl)
      ? await launch(widget.book.pdfUrl)
      : throw 'Could not launch ${widget.book.pdfUrl}';
}
