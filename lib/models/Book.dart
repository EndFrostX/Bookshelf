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
    this.pages,
    this.views = 0,
    this.createdAt,
  });

  final int id;
  final String title;
  final String author;
  final String description;
  final String pdfUrl;
  final int categoryId;
  final String published;
  final int pages;
  final int views;
  final String createdAt;

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        author: json["author"] == null ? null : json["author"],
        description: json["description"] == null ? null : json["description"],
        pdfUrl: json["pdfUrl"] == null ? null : json["pdfUrl"],
        categoryId: json["category_id"] == null ? null : json["category_id"],
        published: json["published"] == null ? null : json["published"],
        pages: json["page"] == null ? null : json["page"],
        views: json["view"] == null ? null : json["view"],
        createdAt: json["createdAt"] == null ? null : json["createdAt"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "author": author,
        "description": description,
        "pdfUrl": pdfUrl,
        "category_id": categoryId,
        "published": published,
        "pages": pages,
        "createdAt": createdAt != null ? createdAt : DateTime.now().toString(),
      };
}
