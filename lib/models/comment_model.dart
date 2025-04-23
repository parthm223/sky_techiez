class CommentModel {
  final int userId;
  final String comment;
  final String createdAt;

  CommentModel({
    required this.userId,
    required this.comment,
    required this.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      userId: json['user_id'] ?? 0,
      comment: json['comment'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'comment': comment,
      'created_at': createdAt,
    };
  }
}
