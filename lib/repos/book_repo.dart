import 'package:bookshelf/models/Book.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

String address = "localhost:3000";

Future<List<Book>> getAllPost() async {
  Uri url = Uri.http(address, "/book");
  Response res = await get(url);

  return compute(bookFromJson, res.body);
}
