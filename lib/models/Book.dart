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
    this.view = 0,
  });

  final int id;
  final String title;
  final String author;
  final String description;
  final String pdfUrl;
  final int categoryId;
  final String published;
  final int page;
  final int view;

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        author: json["author"] == null ? null : json["author"],
        description: json["description"] == null ? null : json["description"],
        pdfUrl: json["pdfUrl"] == null ? null : json["pdfUrl"],
        categoryId: json["category_id"] == null ? null : json["category_id"],
        published: json["published"] == null ? null : json["published"],
        page: json["page"] == null ? null : json["page"],
        view: json["view"] == null ? null : json["view"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "title": title == null ? null : title,
        "author": author == null ? null : author,
        "description": description == null ? null : description,
        "pdfUrl": pdfUrl == null ? null : pdfUrl,
        "category_id": categoryId == null ? null : categoryId,
        "published": published == null ? null : published,
        "page": page == null ? null : page,
        "view": view == null ? null : view,
      };
}
