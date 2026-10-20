import 'package:get/get.dart';
import '../data/models/order.dart';
import '../data/mock/mock_data.dart';

/// Controller for the customer dashboard, orders, transactions, notifications, and profile.
class DashboardController extends GetxController {
  final orders = <Order>[].obs;
  final transactions = <Transaction>[].obs;
  final notifications = <AppNotification>[].obs;
  final filteredOrders = <Order>[].obs;
  final orderFilter = 'All'.obs;
  final orderSearchQuery = ''.obs;
  final selectedSidebarIndex = 0.obs;

  // Profile fields (local demonstration only)
  final fullName = 'Demo User'.obs;
  final email = 'demo@resolva.ng'.obs;
  final phone = '+234 800 000 0000'.obs;

  // Support form
  final supportOrderRef = ''.obs;
  final supportIssue = ''.obs;

  @override
  void onInit() {
    super.onInit();
    orders.assignAll(mockOrders);
    transactions.assignAll(mockTransactions);
    notifications.assignAll(mockNotifications);
    filteredOrders.assignAll(mockOrders);
  }

  // Order filtering
  void filterOrders(String filter) {
    orderFilter.value = filter;
    _applyOrderFilters();
  }

  void searchOrders(String query) {
    orderSearchQuery.value = query;
    _applyOrderFilters();
  }

  void _applyOrderFilters() {
    var result = orders.toList();

    if (orderFilter.value != 'All') {
      final status = OrderFulfilmentStatus.values.firstWhere(
        (s) => s.name.toLowerCase() == orderFilter.value.toLowerCase(),
        orElse: () => OrderFulfilmentStatus.pending,
      );
      result = result.where((o) => o.fulfilmentStatus == status).toList();
    }

    if (orderSearchQuery.value.isNotEmpty) {
      final q = orderSearchQuery.value.toLowerCase();
      result = result
          .where((o) =>
              o.id.toLowerCase().contains(q) ||
              o.productName.toLowerCase().contains(q) ||
              o.category.toLowerCase().contains(q))
          .toList();
    }

    filteredOrders.assignAll(result);
  }

  void selectSidebarItem(int index) {
    selectedSidebarIndex.value = index;
  }

  // Dashboard summary
  int get totalOrders => orders.length;
  int get pendingOrders =>
      orders.where((o) => o.fulfilmentStatus == OrderFulfilmentStatus.pending).length;
  int get completedOrders =>
      orders.where((o) => o.fulfilmentStatus == OrderFulfilmentStatus.completed).length;
  double get totalSpent => orders
      .where((o) => o.paymentStatus == OrderPaymentStatus.paid)
      .fold(0.0, (sum, o) => sum + o.amount);

  int get unreadNotifications => notifications.where((n) => !n.isRead).length;

  // Profile updates (local demo)
  void updateProfile({String? name, String? emailAddr, String? phoneNum}) {
    if (name != null) fullName.value = name;
    if (emailAddr != null) email.value = emailAddr;
    if (phoneNum != null) phone.value = phoneNum;
  }

  void markNotificationRead(String id) {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      final n = notifications[index];
      notifications[index] = AppNotification(
        id: n.id,
        title: n.title,
        message: n.message,
        date: n.date,
        type: n.type,
        isRead: true,
      );
    }
  }

  void markAllNotificationsRead() {
    notifications.assignAll(notifications.map((n) => AppNotification(
      id: n.id,
      title: n.title,
      message: n.message,
      date: n.date,
      type: n.type,
      isRead: true,
    )));
  }
}
