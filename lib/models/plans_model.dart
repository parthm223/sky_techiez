class PlansResponse {
  List<Plan>? plans;

  PlansResponse({this.plans});

  PlansResponse.fromJson(Map<String, dynamic> json) {
    if (json['plans'] != null) {
      plans = <Plan>[];
      json['plans'].forEach((v) {
        plans!.add(Plan.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (plans != null) {
      data['plans'] = plans!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Plan {
  int? id;
  String? name;
  String? price;
  String? description;
  int? status;
  int? duration;
  String? createdAt;
  String? updatedAt;

  Plan({
    this.id,
    this.name,
    this.price,
    this.description,
    this.status,
    this.duration,
    this.createdAt,
    this.updatedAt,
  });

  Plan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    description = json['description'];
    status = json['status'];
    duration = json['duration'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    data['description'] = description;
    data['status'] = status;
    data['duration'] = duration;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
