/// Role of a user on the RESOLVA platform.
enum UserRole {
  customer,
  admin,
}

/// Account status of a user on the RESOLVA platform.
enum UserStatus {
  active,
  suspended,
  pendingOnboarding,
}

/// Type of user activity recorded in the platform audit log.
enum ActivityType {
  login,
  logout,
  purchase,
  pinVerified,
  accountCreated,
  accountRemoved,
  statusChanged,
}

/// Summary of a user's most recent purchase.
class LastPurchaseInfo {
  final String orderId;
  final String productName;
  final String category;
  final double amount;
  final DateTime date;

  const LastPurchaseInfo({
    required this.orderId,
    required this.productName,
    required this.category,
    required this.amount,
    required this.date,
  });
}

/// Detailed user profile managed in the RESOLVA Admin Dashboard.
class AdminUserRecord {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final UserRole role;
  final UserStatus status;
  final DateTime joinedAt;
  final DateTime? lastLoginAt;
  final DateTime? lastLogoutAt;
  final bool isCurrentlyOnline;
  final int totalOrders;
  final double totalSpent;
  final bool hasPinConfigured;
  final bool hasAcceptedPolicies;
  final LastPurchaseInfo? lastPurchase;

  const AdminUserRecord({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    this.role = UserRole.customer,
    this.status = UserStatus.active,
    required this.joinedAt,
    this.lastLoginAt,
    this.lastLogoutAt,
    this.isCurrentlyOnline = false,
    this.totalOrders = 0,
    this.totalSpent = 0,
    this.hasPinConfigured = true,
    this.hasAcceptedPolicies = true,
    this.lastPurchase,
  });

  AdminUserRecord copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    UserRole? role,
    UserStatus? status,
    DateTime? joinedAt,
    DateTime? lastLoginAt,
    DateTime? lastLogoutAt,
    bool? isCurrentlyOnline,
    int? totalOrders,
    double? totalSpent,
    bool? hasPinConfigured,
    bool? hasAcceptedPolicies,
    LastPurchaseInfo? lastPurchase,
  }) {
    return AdminUserRecord(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      status: status ?? this.status,
      joinedAt: joinedAt ?? this.joinedAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      lastLogoutAt: lastLogoutAt ?? this.lastLogoutAt,
      isCurrentlyOnline: isCurrentlyOnline ?? this.isCurrentlyOnline,
      totalOrders: totalOrders ?? this.totalOrders,
      totalSpent: totalSpent ?? this.totalSpent,
      hasPinConfigured: hasPinConfigured ?? this.hasPinConfigured,
      hasAcceptedPolicies: hasAcceptedPolicies ?? this.hasAcceptedPolicies,
      lastPurchase: lastPurchase ?? this.lastPurchase,
    );
  }
}

/// Single activity / session event in the Admin Activity & Session Log.
class UserActivityLog {
  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final ActivityType type;
  final String description;
  final DateTime timestamp;
  final String ipOrDevice;
  final double? amount;

  const UserActivityLog({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.type,
    required this.description,
    required this.timestamp,
    this.ipOrDevice = 'Chrome • Windows',
    this.amount,
  });
}

