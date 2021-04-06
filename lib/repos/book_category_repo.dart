import 'package:bookshelf/models/BookCategoryResponse.dart';
import 'package:bookshelf/repos/repo_config.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

Future<BookCategoryResponse> getAllBookCategories() async {
  Uri url = Uri.http(api_address, "$api_group/book-categories");
  Response res = await get(url);

  if (res.statusCode == 200) {
    return compute(bookCategoryResponseFromJson, res.body);
  } else {
    throw Exception("Connection Failed");
  }
}
