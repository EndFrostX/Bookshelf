import 'package:bookshelf/Pages/CategoryDetail.dart';
import 'package:bookshelf/models/Book.dart';
import 'package:bookshelf/models/BookCategory.dart';
import 'package:bookshelf/models/BookCategoryResponse.dart';
import 'package:bookshelf/repos/book_category_repo.dart';
import 'package:bookshelf/repos/book_repo.dart';
import 'package:flutter/material.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<Book> _allBooks;
  Future<BookCategoryResponse> _fetchAllCategories;
  List<BookCategory> _allCategories;

  get _myBody {
    return Container(
      child: FutureBuilder<BookCategoryResponse>(
        future: _fetchAllCategories,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            _allCategories = snapshot.data.data;
            return _categoryList;
          }
          return Center(
            child: RefreshProgressIndicator(
                // valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                ),
          );
        },
      ),
    );
  }

  get _categoryList {
    return RefreshIndicator(
      onRefresh: () {
        setState(() {
          _fetchAllCategories = getAllBookCategories();
        });
        return _fetchAllCategories;
      },
      child: ListView.builder(
        itemCount: _allCategories.length,
        itemBuilder: (_, index) {
          return _categoryItem(_allCategories[index]);
        },
      ),
    );
  }

  _categoryItem(BookCategory item) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => CategoryDetailPage(category: item),
          ),
        );
      },
      child: ListTile(
        title: Text(item.name),
        subtitle: Text("books: ${getAmountOfBook(item)}"),
        trailing: Icon(Icons.navigate_next),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _fetchAllBooks();
    setState(() {
      _fetchAllCategories = getAllBookCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _myBody,
    );
  }

  void _fetchAllBooks() async {
    await getAllBooks().then((value) {
      setState(() {
        _allBooks = value.data;
      });
    });
  }

  String getAmountOfBook(BookCategory item) {
    return _allBooks
        .where((e) => e.categoryId == item.id)
        .toList()
        .length
        .toString();
  }
}
