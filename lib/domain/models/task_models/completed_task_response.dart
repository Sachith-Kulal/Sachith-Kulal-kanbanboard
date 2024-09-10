import 'dart:convert';

class CompletedTaskResponse {
  List<Item>? items;

  CompletedTaskResponse({
    this.items,
  });

  factory CompletedTaskResponse.fromRawJson(String str) =>
      CompletedTaskResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CompletedTaskResponse.fromJson(Map<String, dynamic> json) =>
      CompletedTaskResponse(
        items: json["items"] == null
            ? []
            : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "items": items == null
            ? []
            : List<dynamic>.from(items!.map((x) => x.toJson())),
      };
}

class Item {
  DateTime? completedAt;
  String? content;
  String? id;
  ItemObject? itemObject;
  String? projectId;
  String? sectionId;
  String? taskId;

  Item({
    this.completedAt,
    this.content,
    this.id,
    this.itemObject,
    this.projectId,
    this.sectionId,
    this.taskId,
  });

  factory Item.fromRawJson(String str) => Item.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        completedAt: json["completed_at"] == null
            ? null
            : DateTime.parse(json["completed_at"]),
        content: json["content"],
        id: json["id"],
        itemObject: json["item_object"] == null
            ? null
            : ItemObject.fromJson(json["item_object"]),
        projectId: json["project_id"],
        sectionId: json["section_id"],
        taskId: json["task_id"],
      );

  Map<String, dynamic> toJson() => {
        "completed_at": completedAt?.toIso8601String(),
        "content": content,
        "id": id,
        "item_object": itemObject?.toJson(),
        "project_id": projectId,
        "section_id": sectionId,
        "task_id": taskId,
      };
}

class ItemObject {
  DateTime? addedAt;
  String? addedByUid;
  String? content;
  String? description;
  Duration? duration;
  int? priority;
  DateTime? updatedAt;
  String? userId;

  ItemObject({
    this.addedAt,
    this.addedByUid,
    this.content,
    this.description,
    this.duration,
    this.priority,
    this.updatedAt,
    this.userId,
  });

  factory ItemObject.fromRawJson(String str) =>
      ItemObject.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ItemObject.fromJson(Map<String, dynamic> json) => ItemObject(
        addedAt:
            json["added_at"] == null ? null : DateTime.parse(json["added_at"]),
        addedByUid: json["added_by_uid"],
        content: json["content"],
        description: json["description"],
        duration: json["duration"] == null
            ? Duration(amount: 0, unit: "minute")
            : Duration.fromJson(json["duration"]),
        priority: json["priority"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "added_at": addedAt?.toIso8601String(),
        "added_by_uid": addedByUid,
        "content": content,
        "description": description,
        "duration": duration?.toJson(),
        "priority": priority,
        "updated_at": updatedAt?.toIso8601String(),
        "user_id": userId,
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
        amount: json["amount"],
        unit: json["unit"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "unit": unit,
      };
}
