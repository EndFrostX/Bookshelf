// To parse this JSON data, do
//
//     final bookCategory = bookCategoryFromJson(jsonString);

import 'dart:convert';

List<BookCategory> bookCategoryFromJson(String str) => List<BookCategory>.from(
    json.decode(str).map((x) => BookCategory.fromJson(x)));

String bookCategoryToJson(List<BookCategory> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BookCategory {
  BookCategory({
    this.id,
    this.name,
  });

  final int id;
  final String name;

  factory BookCategory.fromJson(Map<String, dynamic> json) => BookCategory(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
      };
}
