import 'package:bookshelf/Pages/Detail.dart';
import 'package:bookshelf/Pages/Edit.dart';
import 'package:bookshelf/models/Book.dart';
import 'package:bookshelf/models/BookCategory.dart';
import 'package:bookshelf/models/BookResponse.dart';
import 'package:bookshelf/repos/book_repo.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class CategoryDetailPage extends StatefulWidget {
  CategoryDetailPage({this.category});

  BookCategory category;

  @override
  _CategoryDetailPageState createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  double _width;
  double _height;
  Future<BookResponse> _futureData;
  List<Book> books;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _futureData = getAllBooks();
    });
  }

  get _buildBody {
    return FutureBuilder<BookResponse>(
      future: _futureData,
      builder: (_,snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          books = snapshot.data.data
              .where((e) => e.categoryId == widget.category.id)
              .toList();

          if (books.isNotEmpty) {
            return Container(
              child: RefreshIndicator(
                onRefresh: (){
                  setState(() {
                    _futureData = getAllBooks();
                  });
                  return _futureData;
                },
                child: ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (_, index) {
                    return _myContainerList(books[index]);
                  },
                ),
              ),
            );
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: _width,
                  height: 300,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage("https://cdni.iconscout.com/illustration/premium/thumb/search-result-not-found-3428237-2902696.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Text("Category ${widget.category.name} is empty!"),
                ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).primaryColor),
                  ),
                  icon: Icon(Icons.refresh),
                  label: Text("Refresh"),
                  onPressed: () {
                    setState(() {
                      _futureData = getAllBooks();
                    });
                  },
                ),
              ],
            ),
          );
        }
        return Center(
          child: RefreshProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          ),
        );
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
        ))
            .then((value) {
          setState(() {
            _futureData = getAllBooks();
          });
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
          setState(() {
            _futureData = getAllBooks();
          });
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
      height: _height * 0.3,
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
    bool _bookmark = false;
    return InkWell(
      child: Container(
        alignment: Alignment.center,
        child: _bookmark
            ? Icon(
                Icons.bookmark,
                color: Colors.amber,
              )
            : Icon(
                Icons.check,
                color: Colors.lightGreen,
              ),
      ),
      onTap: () {
        _message("Added to bookmark", Colors.lightGreen);
        _bookmark = !_bookmark;
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
                        .then((value) {});
                  }),
                  _contentDialogue("Delete", Icons.delete, function: () {
                    Navigator.of(context).pop();
                    deleteBook(book).then((value) {
                      setState(() {
                        _futureData = getAllBooks();
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

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
      ),
      body: _buildBody,
    );
  }

  void _message(String text, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      backgroundColor: color,
    ));
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
