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

  int id;
  String name;

  factory BookCategory.fromJson(Map<String, dynamic> json) => BookCategory(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  @override
  String toString() {
    return "$name $id";
  }
}
