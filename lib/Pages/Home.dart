import 'package:bookshelf/Pages/BookMark.dart';
import 'package:bookshelf/Pages/Category.dart';
import 'package:bookshelf/models/Book.dart';
import 'package:bookshelf/repos/book_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:page_transition/page_transition.dart';

import 'Create.dart';
import 'Detail.dart';
import 'PrivacyPolicy.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double _width;
  double _height;
  Future<dynamic> _futureData;
  List<Book> _data;
  var _saved = Set<Book>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _futureData = getAllBooks();

  }
  @override
  Widget build(BuildContext context) {
    _height = MediaQuery
        .of(context)
        .size
        .height;
    _width = MediaQuery
        .of(context)
        .size
        .width;

    return Scaffold(
      appBar: _myAppBar,
      body: _myBody,
      drawer: _myDrawer,
    );
  }

  get _myDrawer {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.deepPurple,
                    Colors.purpleAccent,
                  ]),
                  image: DecorationImage(
                    image: NetworkImage("https://i.imgur.com/XiyhRr9.jpg"),
                    fit: BoxFit.cover,
                  )),
              child: Container()),
          _myDrawerList(Icons.home, "General", colored: Colors.grey),
          _myDrawerList(Icons.category, "Category",
              page: CategoryPage()),
          _myDrawerList(Icons.bookmark, "BookMark",
              page: BookMarkPage()),
          _myDrawerList(Icons.policy, "Privacy & Policy",
              page: PrivacyPolicyPage()),
        ],
      ),
    );
  }

  _myDrawerList(IconData icon, String text, {Widget page, Color colored = Colors.amber}) {
    return InkWell(
        child: Container(
          margin: EdgeInsets.only(bottom: 10),
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: 60,
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Icon(icon, color: colored),
              Container(
                padding: EdgeInsets.only(left: 35),
                child: Text(
                  text,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Expanded(
                  child: Container(
                    padding: EdgeInsets.only(right: 10),
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.arrow_forward, color: colored),
                  )),
            ],
          ),
        ),
      onTap: () {
        Navigator.of(context).push(PageTransition(child: page, type: PageTransitionType.rightToLeftWithFade));
      }
    );
  }

  get _myAppBar {
    return AppBar(
      actions: [
        Container(
          child: IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(PageTransition(
                child: CreatePage(),
                type: PageTransitionType.rightToLeft,
              ));
            },
          ),
        ),
      ],
    );
  }

  get _myBody {
    print(_futureData);
    if(_futureData == null){
      return Center(child: Container(
        child: Text("It seems there's no upload books right now, "
            "please come back another time", style: TextStyle(color: Colors.grey.withOpacity(0.4)))
      ));
    }
    else{
    return FutureBuilder(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if(snapshot.data == null){
              return Center(child: Container(
                  width: _width * 0.8,
                  child: Text("It seems there's no uploaded book right now, "
                  "please come back another time", style: TextStyle(color: Colors.grey, fontSize: 16))));
              }
            else {
              _data = snapshot.data.data;
              return _myListView;
            }
          }
          else {
            return CircularProgressIndicator();
          }
        });
    }
  }

  get _myListView {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: _data.length,
        itemBuilder: (context, index) {
          return _buildListView(_data[index]);
        });
  }

  _buildListView(dynamic book) {
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
    return Container(
      height: _height * 0.2,
      width: _width,
      margin: EdgeInsets.zero,
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _containerPicture(book.pdfUrl),
          _containerText(title: book.title,
              author: book.author,
              description: book.description,
              published: book.published),
          _containerIcon(book),
        ],
      ),
    );
  }

  _containerPicture(String img) {
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
          child: DetailPage(),
          type: PageTransitionType.rightToLeftWithFade,
        ));
      },
      onLongPress: (){
        _showDialogue();
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
        _saved.add(book);
        _bookmark = !_bookmark;
      },
    );
  }

  get _showDialogue {
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
              _contentDialogue("Edit", Icons.edit),
            ],
          ),
        ),
      );
    });
  }

  _contentDialogue(String text, IconData icon) {
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
        onTap: (){},
    );
  }
}
