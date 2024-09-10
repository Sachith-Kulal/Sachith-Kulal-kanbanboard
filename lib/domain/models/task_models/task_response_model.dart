import 'dart:convert';

import 'package:get/get.dart';

class TaskResponse {
  String? id;
  String? projectId;
  String? sectionId;
  int? order;
  String? content;
  String? description;
  RxBool isCompleted = false.obs;
  int? priority;
  String? creatorId;
  DateTime? createdAt;
  Duration? duration;

  TaskResponse({
    this.id,
    this.projectId,
    this.sectionId,
    this.order,
    this.content,
    this.description,
    // required this.isCompleted,
    this.priority,
    this.creatorId,
    this.createdAt,
    this.duration,
  });

  factory TaskResponse.fromRawJson(String str) =>
      TaskResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TaskResponse.fromJson(Map<String, dynamic> json) => TaskResponse(
        id: json["id"],
        projectId: json["project_id"],
        sectionId: json["section_id"],
        order: json["order"],
        content: json["content"],
        description: json["description"],
        // isCompleted: json["is_completed"],
        priority: json["priority"],
        creatorId: json["creator_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        duration: json["duration"] == null
            ? Duration(amount: 0, unit: "minute")
            : Duration.fromJson(json["duration"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "project_id": projectId,
        "section_id": sectionId,
        "order": order,
        "content": content,
        "description": description,
        "is_completed": isCompleted,
        "priority": priority,
        "creator_id": creatorId,
        "created_at": createdAt?.toIso8601String(),
        "duration": duration?.toJson(),
      };
}

class Duration {
  int? amount;
  String? unit;

  Duration({
    this.amount,
    this.unit,
  });

  factory Duration.fromRawJson(String str) =>
      Duration.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Duration.fromJson(Map<String, dynamic> json) => Duration(
        amount: json["amount"] ?? 0,
        unit: json["unit"] ?? "minute",
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "unit": unit,
      };
}
