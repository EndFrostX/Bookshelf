import 'package:bookshelf/Class/BookMarkPreferences.dart';
import 'package:bookshelf/models/Book.dart';
import 'package:bookshelf/models/BookResponse.dart';
import 'package:bookshelf/repos/book_repo.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

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
    print(_id);

  }

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
      body: _futureBuilder,
    );
  }
  get _myAppBar{
    return AppBar(
      title: Text("hi"),
    );
  }
  get _futureBuilder {
    if(_id.isEmpty)
    {
      return Center(child: Container(child: Text("You haven't bookmark anything yet.",style: TextStyle(color: Colors.grey, fontSize: 16),),),);
    }
    else{
      return FutureBuilder(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done)
          {
            _data = snapshot.data.data;
            return _myBody;
          }
          else {
            return Center(child: CircularProgressIndicator());
          }
        },
      );
    }
  }

  get _myBody {
    return ListView.builder(
      itemCount: _data.length,
      itemBuilder: (context, index) {
        if(_id.contains(_data[index].id.toString())){
          if (index < _data.length - 1) {
            return Column(
              children: [
                _myContainerList(_data[index]),
                Divider(),
              ],
            );
          }
          return _myContainerList(_data[index]);
        }
        else{
          return Text("");
        }
      },
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
            _containerPicture(book),
            _containerText(book),
            _containerIcon(book),
          ],
        ),
      ),
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(
          builder: (_) => DetailPage(book),
        ));
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
        ));
      },
      onLongPress: () {
        _showDialogue(book);
      },
    );
  }

  _containerText(Book book) {
    return Container(
      padding: EdgeInsets.only(left: 10),
      width: _width * 0.45,
      height: _height * 0.3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
          SizedBox(
            height: 5,
          ),
          Text(
            book.author,
            style: TextStyle(
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
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
          Text(
            "published ${book.published}",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            book.description,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
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
          child: bookmark ? Icon(Icons.check, color: Colors.lightGreen,)
              : Icon(Icons.bookmark, color: Colors.amber,)
      ),
      onTap: () async{
        //if false do this
        if(!bookmark){
          setState(() {
            _id.add(book.id.toString());
          });
          await BookMarkPreferences.setBookID(_id);
          _message("Added to bookmark", Colors.lightGreen);

        }
        else{
          setState((){
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
            title: Text("Option"),
            backgroundColor: Colors.white,
            actions: [
              ElevatedButton(
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
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => EditPage(book),
                      ),
                    );
                  }),
                  _contentDialogue("Remove from Bookmark.", Icons.remove, function: () {
                      setState(() {
                        _data.remove(book);
                      });
                      _message("Successfully Removed!", Colors.redAccent);
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
          width: MediaQuery.of(context).size.width,
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

  void refresh() {
    setState(() {
      _futureData = getAllBooks();
    });
  }
}
