import 'package:bookshelf/models/BookCategory.dart';
import 'package:bookshelf/models/ServerResponse.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

String address = "localhost:3000";

Future<ServerResponse> getAllBookCategories() async {
  Uri url = Uri.http(address, "/book-categories");
  Response res = await get(url);

  if (res.statusCode == 200) {
    return compute(serverResponseFromJson, res.body);
  } else {
    throw Exception("Connection Failed");
  }
}
