import 'package:bookshelf/models/Book.dart';
import 'package:bookshelf/models/BookResponse.dart';
import 'package:bookshelf/repos/repo_config.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

Future<BookResponse> getAllBooks() async {
  Uri url = Uri.http(api_address, "$api_group/books");
  Response res = await get(url);

  if (res.statusCode == 200) {
    return compute(bookResponseFromJson, res.body);
  } else {
    throw Exception("Connection Failed");
  }
}

Future<BookResponse> insertBook(Book item) async {
  Uri url = Uri.http(api_address, "$api_group/books");
  Response res = await post(url, body: item.toJson());

  if (res.statusCode == 200) {
    return compute(bookResponseFromJson, res.body);
  } else {
    throw Exception("Connection Failed");
  }
}

Future<BookResponse> updateBook(Book item) async {
  Uri url = Uri.http(api_address, "$api_group/books");
  Response res = await put(url, body: item.toJson());

  if (res.statusCode == 200) {
    return compute(bookResponseFromJson, res.body);
  } else {
    throw Exception("Connection Failed");
  }
}

Future<BookResponse> deleteBook(Book item) async {
  Uri url = Uri.http(api_address, "$api_group/books/${item.id}");
  Response res = await delete(url);

  if (res.statusCode == 200) {
    return compute(bookResponseFromJson, res.body);
  } else {
    throw Exception("Connection Failed");
  }
}
