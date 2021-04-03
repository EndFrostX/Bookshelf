// To parse this JSON data, do
//
//     final bookCategoryResponse = bookCategoryResponseFromJson(jsonString);

import 'dart:convert';

import 'package:bookshelf/models/BookCategory.dart';

BookCategoryResponse bookCategoryResponseFromJson(String str) =>
    BookCategoryResponse.fromJson(json.decode(str));

String bookCategoryResponseToJson(BookCategoryResponse data) =>
    json.encode(data.toJson());

class BookCategoryResponse {
  BookCategoryResponse({
    this.error,
    this.message,
    this.data,
  });

  final bool error;
  final dynamic message;
  final List<BookCategory> data;

  factory BookCategoryResponse.fromJson(Map<String, dynamic> json) =>
      BookCategoryResponse(
        error: json["error"] == null ? null : json["error"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : List<BookCategory>.from(
                json["data"].map((x) => BookCategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error == null ? null : error,
        "message": message,
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toJson())),
      };
}
