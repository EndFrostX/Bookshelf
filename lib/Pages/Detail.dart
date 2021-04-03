import 'package:bookshelf/models/Book.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
      bottomNavigationBar: _myBottonNavigation,
    );
  }
  get _myBottonNavigation{
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _button,
          _button,
          _button,
          _button,
        ],
      ),
    );
  }
  get _button{
    return Container(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: ElevatedButton(child: Text("hi"), style: ButtonStyle(), onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CategoryPage()));
        },)
    );
  }
  get _myAppBar{
    return AppBar(
      title: Text("hi"),
    );
  }
  get _myBody{
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          _bookCoverPDF,
          SizedBox(height: 10,),
          Row(
            children: [
              _description("Status: ", size: 25, weight: FontWeight.bold, opacity: 0.5),
              Expanded(child: Icon(Icons.done)),
            ],
          ),
          _description("Book: I'm a spider, so what?", size: 35, weight: FontWeight.bold, opacity: 0.7),
          _description("Author: Rithiya", size: 30, weight: FontWeight.bold, opacity: 0.7),
          _description("Pages: 250", size: 25, weight: FontWeight.normal, style: FontStyle.italic, opacity: 0.7),
        ],
      ),
    );
  }
  get _bookCoverPDF{
    return Center(
      child: Card(
          elevation: 12,
          child: Container(

            width: MediaQuery.of(context).size.width * 0.60,
            height: 200,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage("https://149349728.v2.pressablecdn.com/wp-content/uploads/2019/08/The-Crying-Book-by-Heather-Christie-1.jpg"),
                fit: BoxFit.cover,
              )
            ),
          )),
    );
}
  _description(String text,{double size, FontWeight weight, FontStyle style = FontStyle.normal, double opacity}){
    return Container(
      margin: EdgeInsets.only(left: 15, bottom: 15),
      child: Text(text, style: TextStyle(fontSize:  size, fontWeight: weight, fontStyle: style, color: Colors.grey.withOpacity(opacity)),
      ),
    );
  }
}
