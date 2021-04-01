// To parse this JSON data, do
//
//     final book = bookFromJson(jsonString);

import 'dart:convert';

List<Book> bookFromJson(String str) =>
    List<Book>.from(json.decode(str).map((x) => Book.fromJson(x)));

String bookToJson(List<Book> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Book {
  Book({
    this.id,
    this.title,
    this.author,
    this.description,
    this.pdfUrl,
    this.categoryId,
    this.published,
    this.page,
    this.view,
  });

  int id;
  String title;
  String author;
  String description;
  String pdfUrl;
  int categoryId;
  String published;
  int page;
  int view;

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json["id"],
        title: json["title"],
        author: json["author"],
        description: json["description"] == null ? null : json["description"],
        pdfUrl: json["pdfUrl"],
        categoryId: json["category_id"],
        published: json["published"],
        page: json["page"],
        view: json["view"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "author": author,
        "description": description == null ? null : description,
        "pdfUrl": pdfUrl,
        "category_id": categoryId,
        "published": published,
        "page": page,
        "view": view,
      };
}
