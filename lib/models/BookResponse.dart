// To parse this JSON data, do
//
//     final bookResponse = bookResponseFromJson(jsonString);

import 'dart:convert';

import 'package:bookshelf/models/Book.dart';

BookResponse bookResponseFromJson(String str) =>
    BookResponse.fromJson(json.decode(str));

String bookResponseToJson(BookResponse data) => json.encode(data.toJson());

class BookResponse {
  BookResponse({
    this.error,
    this.message,
    this.data,
  });

  final bool error;
  final dynamic message;
  final List<Book> data;

  factory BookResponse.fromJson(Map<String, dynamic> json) => BookResponse(
        error: json["error"] == null ? null : json["error"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : List<Book>.from(json["data"].map((x) => Book.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error == null ? null : error,
        "message": message,
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toJson())),
      };
}
