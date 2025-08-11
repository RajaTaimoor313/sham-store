class Notification {
  final int id;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final Map<String, dynamic>? data;
  final DateTime createdAt;
  final DateTime updatedAt;

  Notification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    this.data,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? '',
      isRead: json['is_read'] ?? false,
      data: json['data'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type,
      'is_read': isRead,
      'data': data,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Notification copyWith({
    int? id,
    String? title,
    String? message,
    String? type,
    bool? isRead,
    Map<String, dynamic>? data,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Notification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class NotificationSettings {
  final int id;
  final int userId;
  final bool emailNotifications;
  final bool pushNotifications;
  final bool orderNotifications;
  final bool userRegistration;
  final bool sellerNotifications;
  final bool systemAlerts;
  final bool marketingEmails;
  final bool weeklyReports;
  final bool monthlyReports;
  final DateTime createdAt;
  final DateTime updatedAt;

  NotificationSettings({
    required this.id,
    required this.userId,
    required this.emailNotifications,
    required this.pushNotifications,
    required this.orderNotifications,
    required this.userRegistration,
    required this.sellerNotifications,
    required this.systemAlerts,
    required this.marketingEmails,
    required this.weeklyReports,
    required this.monthlyReports,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      emailNotifications: json['email_notifications'] ?? true,
      pushNotifications: json['push_notifications'] ?? true,
      orderNotifications: json['order_notifications'] ?? true,
      userRegistration: json['user_registration'] ?? true,
      sellerNotifications: json['seller_notifications'] ?? true,
      systemAlerts: json['system_alerts'] ?? true,
      marketingEmails: json['marketing_emails'] ?? true,
      weeklyReports: json['weekly_reports'] ?? true,
      monthlyReports: json['monthly_reports'] ?? true,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'email_notifications': emailNotifications,
      'push_notifications': pushNotifications,
      'order_notifications': orderNotifications,
      'user_registration': userRegistration,
      'seller_notifications': sellerNotifications,
      'system_alerts': systemAlerts,
      'marketing_emails': marketingEmails,
      'weekly_reports': weeklyReports,
      'monthly_reports': monthlyReports,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  NotificationSettings copyWith({
    int? id,
    int? userId,
    bool? emailNotifications,
    bool? pushNotifications,
    bool? orderNotifications,
    bool? userRegistration,
    bool? sellerNotifications,
    bool? systemAlerts,
    bool? marketingEmails,
    bool? weeklyReports,
    bool? monthlyReports,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotificationSettings(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      orderNotifications: orderNotifications ?? this.orderNotifications,
      userRegistration: userRegistration ?? this.userRegistration,
      sellerNotifications: sellerNotifications ?? this.sellerNotifications,
      systemAlerts: systemAlerts ?? this.systemAlerts,
      marketingEmails: marketingEmails ?? this.marketingEmails,
      weeklyReports: weeklyReports ?? this.weeklyReports,
      monthlyReports: monthlyReports ?? this.monthlyReports,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

// Request models for API calls
class CreateNotificationSettingsRequest {
  final int userId;
  final bool emailNotifications;
  final bool pushNotifications;
  final bool orderNotifications;
  final bool userRegistration;
  final bool sellerNotifications;
  final bool systemAlerts;
  final bool marketingEmails;
  final bool weeklyReports;
  final bool monthlyReports;

  CreateNotificationSettingsRequest({
    required this.userId,
    required this.emailNotifications,
    required this.pushNotifications,
    required this.orderNotifications,
    required this.userRegistration,
    required this.sellerNotifications,
    required this.systemAlerts,
    required this.marketingEmails,
    required this.weeklyReports,
    required this.monthlyReports,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'email_notifications': emailNotifications,
      'push_notifications': pushNotifications,
      'order_notifications': orderNotifications,
      'user_registration': userRegistration,
      'seller_notifications': sellerNotifications,
      'system_alerts': systemAlerts,
      'marketing_emails': marketingEmails,
      'weekly_reports': weeklyReports,
      'monthly_reports': monthlyReports,
    };
  }
}

class UpdateNotificationSettingsRequest {
  final int? userId;
  final bool? emailNotifications;
  final bool? pushNotifications;
  final bool? orderNotifications;
  final bool? userRegistration;
  final bool? sellerNotifications;
  final bool? systemAlerts;
  final bool? marketingEmails;
  final bool? weeklyReports;
  final bool? monthlyReports;

  UpdateNotificationSettingsRequest({
    this.userId,
    this.emailNotifications,
    this.pushNotifications,
    this.orderNotifications,
    this.userRegistration,
    this.sellerNotifications,
    this.systemAlerts,
    this.marketingEmails,
    this.weeklyReports,
    this.monthlyReports,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (userId != null) data['user_id'] = userId;
    if (emailNotifications != null) {
      data['email_notifications'] = emailNotifications;
    }
    if (pushNotifications != null) {
      data['push_notifications'] = pushNotifications;
    }
    if (orderNotifications != null) {
      data['order_notifications'] = orderNotifications;
    }
    if (userRegistration != null) data['user_registration'] = userRegistration;
    if (sellerNotifications != null) {
      data['seller_notifications'] = sellerNotifications;
    }
    if (systemAlerts != null) data['system_alerts'] = systemAlerts;
    if (marketingEmails != null) data['marketing_emails'] = marketingEmails;
    if (weeklyReports != null) data['weekly_reports'] = weeklyReports;
    if (monthlyReports != null) data['monthly_reports'] = monthlyReports;
    return data;
  }
}

class MarkNotificationsAsReadRequest {
  final List<int> notificationIds;

  MarkNotificationsAsReadRequest({required this.notificationIds});

  Map<String, dynamic> toJson() {
    return {'notification_ids': notificationIds};
  }
}
