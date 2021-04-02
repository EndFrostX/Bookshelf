// To parse this JSON data, do
//
//     final serverResponse = serverResponseFromJson(jsonString);

import 'dart:convert';

ServerResponse serverResponseFromJson(String str) =>
    ServerResponse.fromJson(json.decode(str));

String serverResponseToJson(ServerResponse data) => json.encode(data.toJson());

class ServerResponse {
  ServerResponse({
    this.error,
    this.message,
    this.data,
  });

  final bool error;
  final String message;
  final List<dynamic> data;

  factory ServerResponse.fromJson(Map<String, dynamic> json) => ServerResponse(
        error: json["error"] == null ? null : json["error"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<dynamic>.from(json["data"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "error": error == null ? null : error,
        "message": message == null ? null : message,
        "data": data == null ? null : List<dynamic>.from(data.map((x) => x)),
      };
}
