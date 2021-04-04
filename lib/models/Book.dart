// To parse this JSON data, do
//
//     final book = bookFromJson(jsonString);

import 'dart:convert';

import 'package:bookshelf/models/BookCategory.dart';

Book bookFromJson(String str) => Book.fromJson(json.decode(str));

String bookToJson(Book data) => json.encode(data.toJson());

class Book {
  Book({
    this.id,
    this.title,
    this.pdfUrl,
    this.author,
    this.description,
    this.published,
    this.pages,
    this.views,
    this.createdAt,
    this.categoryId,
    this.category,
  });

  int id;
  String title;
  String pdfUrl;
  String author;
  String description;
  String published;
  int pages;
  int views;
  DateTime createdAt;
  int categoryId;
  BookCategory category;

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json["id"],
        title: json["title"],
        pdfUrl: json["pdfUrl"],
        author: json["author"],
        description: json["description"],
        published: json["published"],
        pages: json["pages"],
        views: json["views"],
        createdAt: DateTime.parse(json["createdAt"]),
        categoryId: json["category_id"],
        category: BookCategory.fromJson(json["category"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "pdfUrl": pdfUrl,
        "author": author,
        "description": description,
        "published": published,
        "pages": pages,
        "views": views,
        "createdAt": createdAt.toIso8601String(),
        "category_id": categoryId,
      };
}
