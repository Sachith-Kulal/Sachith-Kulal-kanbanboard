import 'dart:convert';

class SectionResponse {
  String? id;
  String? v2Id;
  String? projectId;
  String? v2ProjectId;
  int? order;
  String? name;

  SectionResponse({
    this.id,
    this.v2Id,
    this.projectId,
    this.v2ProjectId,
    this.order,
    this.name,
  });

  factory SectionResponse.fromRawJson(String str) =>
      SectionResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SectionResponse.fromJson(Map<String, dynamic> json) =>
      SectionResponse(
        id: json["id"],
        v2Id: json["v2_id"],
        projectId: json["project_id"],
        v2ProjectId: json["v2_project_id"],
        order: json["order"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "v2_id": v2Id,
        "project_id": projectId,
        "v2_project_id": v2ProjectId,
        "order": order,
        "name": name,
      };
}
