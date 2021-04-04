import 'package:bookshelf/Pages/Edit.dart';
import 'package:bookshelf/models/Book.dart';
import 'package:bookshelf/models/BookResponse.dart';
import 'package:bookshelf/repos/book_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatefulWidget {
  DetailPage(this.book);

  Book book;

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool _loading = false;
  Book currentBook;

  _increaseView() async {
    Book _item = currentBook;
    _item.views++;
    await updateBook(_item);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      currentBook = widget.book;
    });

    _increaseView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _myAppBar,
      body: _loading ? Center(child: CircularProgressIndicator()) : _myBody,
    );
  }

  get _readButton {
    return Container(
      child: ElevatedButton.icon(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
        ),
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
      centerTitle: true,
      title: Text("Book Details"),
      actions: [
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            Navigator.of(context)
                .push(
                  MaterialPageRoute(builder: (_) => EditPage(currentBook)),
                )
                .then((value) => _refresh());
          },
        ),
        IconButton(
          icon: Icon(Icons.delete),
          color: Colors.white,
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
                                    deleteBook(currentBook);
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
            _bookCoverPDF,
            SizedBox(
              height: 10,
            ),
            Text(
              currentBook.title,
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
                  "${currentBook.author}",
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
                  "${currentBook.category.name}",
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
                  "${currentBook.published}",
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
              currentBook.description,
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
                      color: Colors.grey[500],
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
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          "${currentBook.pages}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
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
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.remove_red_eye,
                          size: 17,
                          color: Colors.white,
                        ),
                        Text(
                          _viewCalculator(currentBook.views),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
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
                  "https://i.pinimg.com/originals/dd/64/da/dd64da585bc57cb05e5fd4d8ce873f57.png"),
              fit: BoxFit.cover,
            )),
          )),
    );
  }

  void _refresh() async {
    _loading = true;
    await getAllBooks().then((value) {
      setState(() {
        currentBook = value.data.where((e) => e.id == widget.book.id).single;
      });
      _loading = false;
    });
  }

  void _launchURL() async => await canLaunch(currentBook.pdfUrl)
      ? await launch(currentBook.pdfUrl)
      : ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text("Could not launch (${currentBook.pdfUrl})"),
          ),
        );

  String _viewCalculator(int views) {
    if (views >= 1000) {
      double calView = views / 1000;
      return " ${calView.toStringAsFixed(2)}k";
    } else {
      return " ${views}";
    }
  }
}
