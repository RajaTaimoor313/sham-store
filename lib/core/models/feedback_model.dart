class Feedback {
  final int? id;
  final int star;
  final String feedbackContent;
  final int scale;
  final String? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Feedback({
    this.id,
    required this.star,
    required this.feedbackContent,
    required this.scale,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory Feedback.fromJson(Map<String, dynamic> json) {
    return Feedback(
      id: _parseInt(json['id']),
      star: _parseInt(json['star']) ?? 0,
      feedbackContent:
          json['feedback_content'] ?? json['feddback_content'] ?? '',
      scale: _parseInt(json['scale']) ?? 0,
      userId: json['user_id']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  // Helper method to safely parse integers
  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'star': star,
      'feedback_content': feedbackContent,
      'scale': scale,
      if (userId != null) 'user_id': userId,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  Feedback copyWith({
    int? id,
    int? star,
    String? feedbackContent,
    int? scale,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Feedback(
      id: id ?? this.id,
      star: star ?? this.star,
      feedbackContent: feedbackContent ?? this.feedbackContent,
      scale: scale ?? this.scale,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Feedback(id: $id, star: $star, feedbackContent: $feedbackContent, scale: $scale, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Feedback &&
        other.id == id &&
        other.star == star &&
        other.feedbackContent == feedbackContent &&
        other.scale == scale &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        star.hashCode ^
        feedbackContent.hashCode ^
        scale.hashCode ^
        userId.hashCode;
  }
}
