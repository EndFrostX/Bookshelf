import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:page_transition/page_transition.dart';

import 'Create.dart';
import 'Detail.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double _width;
  double _height;

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
      body: _buildListView(),
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
          _myDrawerList(Icons.home, "General"),
          _myDrawerList(Icons.category, "Category"),
          _myDrawerList(Icons.bookmark, "BookMark"),
          _myDrawerList(Icons.policy, "Privacy & Policy"),
        ],
      ),
    );
  }

  _myDrawerList(IconData icon, String text) {
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
              Icon(icon),
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
                    child: Icon(Icons.arrow_forward),
                  )),
            ],
          ),
        ));
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

  // get _myBody {
  //   return FutureBuilder(
  //       future:,
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.done) {
  //           return _myListView;
  //         }
  //         else {
  //           return CircularProgressIndicator();
  //         }
  //       });
  // }
  //
  // get _myListView {
  //   return ListView.builder(
  //       physics: BouncingScrollPhysics(),
  //       itemCount:,
  //       itemBuilder: (context, index) {
  //         return _buildListView();
  //       });
  // }

  _buildListView() {
    return Container(
      width: _width,
      child: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
          _myContainerList(),
          _myContainerList(),
          _myContainerList(),
        ],
      ),
    );
  }

  _myContainerList() {
    return InkWell(
      child: Container(
        height: _height * 0.2,
        width: _width,
        margin: EdgeInsets.zero,
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _containerPicture(
                "https://149349728.v2.pressablecdn.com/wp-content/uploads/2019/08/The-Crying-Book-by-Heather-Christie-1.jpg"),
            _containerText(),
            _containerIcon(),
          ],
        ),
      ),
      onTap: () {
        Navigator.of(context).push(PageTransition(
          child: DetailPage(),
          type: PageTransitionType.rightToLeftWithFade,
        ));
      },
      onLongPress: () {
        _showDialogue;
      },
    );
  }

  _containerPicture(String img) {
    return Card(
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
    );
  }

  _containerText() {
    return Container(
      padding: EdgeInsets.only(left: 10),
      width: _width * 0.45,
      height: _height * 0.3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text("Title: fiasefsd"), Text("Author: fuck")],
      ),
    );
  }

  _containerIcon() {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        child: Icon(Icons.arrow_forward_ios),
      ),
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
              _contentDialogue(),
            ],
          ),
        ),
      );
    });
  }

  _contentDialogue() {
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
              Text("Edit"),
              Expanded(child: Icon(Icons.edit)),
            ],
          ),
        ),
      ),
      onTap: () {},
    );
  }
}
