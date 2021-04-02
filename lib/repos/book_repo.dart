import 'package:bookshelf/models/Book.dart';
import 'package:bookshelf/models/ServerResponse.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

String address = "127.0.0.1:8000";
String group = "/api";

Future<ServerResponse> getAllBooks() async {
  Uri url = Uri.http(address, "$group/books");
  Response res = await get(url);

  if (res.statusCode == 200) {
    return compute(serverResponseFromJson, res.body);
  } else {
    throw Exception("Connection Failed");
  }
}

Future<ServerResponse> insertBook(Book item) async {
  Uri url = Uri.http(address, "$group/books");
  Response res = await post(url, body: item.toJson());

  if (res.statusCode == 200) {
    return compute(serverResponseFromJson, res.body);
  } else {
    throw Exception("Connection Failed");
  }
}

Future<ServerResponse> updateBook(Book item) async {
  Uri url = Uri.http(address, "$group/books");
  Response res = await put(url, body: item.toJson());

  if (res.statusCode == 200) {
    return compute(serverResponseFromJson, res.body);
  } else {
    throw Exception("Connection Failed");
  }
}

Future<ServerResponse> deleteBook(Book item) async {
  Uri url = Uri.http(address, "$group/books/${item.id}");
  Response res = await delete(url);

  if (res.statusCode == 200) {
    return compute(serverResponseFromJson, res.body);
  } else {
    throw Exception("Connection Failed");
  }
}
