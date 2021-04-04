import 'dart:convert';

import 'package:bookshelf/models/Book.dart';
import 'package:bookshelf/models/BookResponse.dart';
import 'package:bookshelf/repos/repo_config.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

Map<String, String> _header = {
  "Content-Type": "application/json",
  "Accept": "application/json",
};

Future<BookResponse> getAllBooks() async {
  Uri url = Uri.https(api_address, "$api_group/books");
  Response res = await get(url);

  if (res.statusCode == 200) {
    return compute(bookResponseFromJson, res.body);
  } else {
    throw Exception();
  }
}

Future<BookResponse> insertBook(Book item) async {
  Uri url = Uri.https(api_address, "$api_group/books");
  Response res = await post(url, body: jsonEncode(item), headers: _header);

  if (res.statusCode == 200) {
    return compute(bookResponseFromJson, res.body);
  } else {
    throw Exception();
  }
}

Future<BookResponse> updateBook(Book item) async {
  Uri url = Uri.https(api_address, "$api_group/books");
  Response res = await put(url, body: jsonEncode(item), headers: _header);

  if (res.statusCode == 200) {
    return compute(bookResponseFromJson, res.body);
  } else {
    throw Exception();
  }
}

Future<BookResponse> deleteBook(Book item) async {
  Uri url = Uri.https(api_address, "$api_group/books/${item.id}");
  Response res = await delete(url);

  if (res.statusCode == 200) {
    return compute(bookResponseFromJson, res.body);
  } else {
    throw Exception();
  }
}
