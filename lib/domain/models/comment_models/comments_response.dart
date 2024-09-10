import 'dart:convert';

class CommentsResponse {
  String? id;
  String? taskId;
  String? content;
  DateTime? postedAt;

  CommentsResponse({
    this.id,
    this.taskId,
    this.content,
    this.postedAt,
  });

  factory CommentsResponse.fromRawJson(String str) =>
      CommentsResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CommentsResponse.fromJson(Map<String, dynamic> json) =>
      CommentsResponse(
        id: json["id"],
        taskId: json["task_id"],
        content: json["content"],
        postedAt: json["posted_at"] == null
            ? null
            : DateTime.parse(json["posted_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "task_id": taskId,
        "content": content,
        "posted_at": postedAt?.toIso8601String(),
      };
}
