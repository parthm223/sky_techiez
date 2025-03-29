class UserLogin {
  int? id;
  String? firstName;
  String? lastName;
  String? dob;
  String? accountId;
  String? phone;
  String? email;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;
  String? profileUrl;
  String? fullName;
  List<Media>? media;

  UserLogin({
    this.id,
    this.firstName,
    this.lastName,
    this.dob,
    this.accountId,
    this.phone,
    this.email,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.profileUrl,
    this.fullName,
    this.media,
  });

  UserLogin.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    dob = json['dob'];
    accountId = json['account_id'];
    phone = json['phone'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    profileUrl = json['profile_url'];
    fullName = json['full_name'];
    if (json['media'] != null) {
      media = [];
      json['media'].forEach((v) {
        media!.add(Media.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['dob'] = dob;
    data['account_id'] = accountId;
    data['phone'] = phone;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['profile_url'] = profileUrl;
    data['full_name'] = fullName;
    if (media != null) {
      data['media'] = media!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Media {
  int? id;
  String? modelType;
  int? modelId;
  String? uuid;
  String? collectionName;
  String? name;
  String? fileName;
  String? mimeType;
  String? disk;
  String? conversionsDisk;
  int? size;
  List<dynamic>? manipulations;
  List<dynamic>? customProperties;
  List<dynamic>? generatedConversions;
  List<dynamic>? responsiveImages;
  int? orderColumn;
  String? createdAt;
  String? updatedAt;
  String? originalUrl;
  String? previewUrl;

  Media({
    this.id,
    this.modelType,
    this.modelId,
    this.uuid,
    this.collectionName,
    this.name,
    this.fileName,
    this.mimeType,
    this.disk,
    this.conversionsDisk,
    this.size,
    this.manipulations,
    this.customProperties,
    this.generatedConversions,
    this.responsiveImages,
    this.orderColumn,
    this.createdAt,
    this.updatedAt,
    this.originalUrl,
    this.previewUrl,
  });

  Media.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    modelType = json['model_type'];
    modelId = json['model_id'];
    uuid = json['uuid'];
    collectionName = json['collection_name'];
    name = json['name'];
    fileName = json['file_name'];
    mimeType = json['mime_type'];
    disk = json['disk'];
    conversionsDisk = json['conversions_disk'];
    size = json['size'];
    manipulations = json['manipulations'] ?? [];
    customProperties = json['custom_properties'] ?? [];
    generatedConversions = json['generated_conversions'] ?? [];
    responsiveImages = json['responsive_images'] ?? [];
    orderColumn = json['order_column'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    originalUrl = json['original_url'];
    previewUrl = json['preview_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['model_type'] = modelType;
    data['model_id'] = modelId;
    data['uuid'] = uuid;
    data['collection_name'] = collectionName;
    data['name'] = name;
    data['file_name'] = fileName;
    data['mime_type'] = mimeType;
    data['disk'] = disk;
    data['conversions_disk'] = conversionsDisk;
    data['size'] = size;
    data['manipulations'] = manipulations;
    data['custom_properties'] = customProperties;
    data['generated_conversions'] = generatedConversions;
    data['responsive_images'] = responsiveImages;
    data['order_column'] = orderColumn;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['original_url'] = originalUrl;
    data['preview_url'] = previewUrl;
    return data;
  }
}
