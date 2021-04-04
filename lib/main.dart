import 'package:bookshelf/Pages/BookMark.dart';
import 'package:bookshelf/Pages/Category.dart';
import 'package:bookshelf/Pages/Create.dart';
import 'package:bookshelf/Pages/PrivacyPolicy.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'Class/BookMarkPreferences.dart';
import 'Pages/Home.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await BookMarkPreferences.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "BookShelf",
      theme: ThemeData(
        primaryColor: Colors.deepOrange,
        accentColor: Colors.deepOrange,

      ),
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Widget> _allPages = [
    Home(),
    CategoryPage(),
    BookMarkPage(),
    PrivacyPolicyPage(),
  ];

  List<String> _allPagesString = [
    "BookShlef",
    "Category",
    "Bookmark",
    "Privacy & Policy",
  ];

  int _currentPage = 0;

  get _myDrawer {
    return Drawer(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.deepPurple,
                    Colors.purpleAccent,
                  ]),
                  image: DecorationImage(
                    image: NetworkImage(
                        "https://i.pinimg.com/originals/dd/64/da/dd64da585bc57cb05e5fd4d8ce873f57.png"
                  ),
                    fit: BoxFit.cover,
                  )),
              child: Container(),
            ),
            _myDrawerList(Icons.home, "General", page: 0),
            _myDrawerList(Icons.category, "Category", page: 1),
            _myDrawerList(Icons.bookmark, "BookMark", page: 2),
            _myDrawerList(Icons.policy, "Privacy & Policy", page: 3),
          ],
        ),
      ),
    );
  }

  _myDrawerList(IconData icon, String text,
      {Color colored = Colors.white, int page}) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        width: MediaQuery.of(context).size.width,
        height: 60,
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Icon(icon, color: colored),
            Container(
              padding: EdgeInsets.only(left: 35),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 20,
                  color: colored,
                ),
              ),
            ),
            Expanded(
                child: Container(
              padding: EdgeInsets.only(right: 10),
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.arrow_forward,
                color: colored,
              ),
            )),
          ],
        ),
      ),
      onTap: () {
        setState(() {
          _currentPage = page;
        });
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_allPagesString[_currentPage],
        ),
      ),
      drawer: _myDrawer,
      body: _allPages[_currentPage],
    );
  }
}
