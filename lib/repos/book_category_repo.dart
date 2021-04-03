import 'package:bookshelf/models/ServerResponse.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';


String address = "samdy-bookshelf-api.herokuapp.com";
String group = "/api/book-categories";


Future<ServerResponse> getAllBookCategories() async {
  Uri url = Uri.http(address, "$group");
  Response res = await get(url);

  if (res.statusCode == 200) {
    return compute(serverResponseFromJson, res.body);
  } else {
    throw Exception("Connection Failed");
  }
}
