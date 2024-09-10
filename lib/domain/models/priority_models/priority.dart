import 'dart:convert';

class Priority {
  int? id;
  String? text;

  Priority({
    this.id,
    this.text,
  });

  factory Priority.fromRawJson(String str) =>
      Priority.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Priority.fromJson(Map<String, dynamic> json) => Priority(
        id: json["id"],
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "text": text,
      };
}
