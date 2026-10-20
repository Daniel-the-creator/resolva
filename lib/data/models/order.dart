/// Model representing a customer order.
class Order {
  final String id;
  final String productName;
  final String category;
  final DateTime date;
  final double amount;
  final OrderPaymentStatus paymentStatus;
  final OrderFulfilmentStatus fulfilmentStatus;
  final String? details;
  final int quantity;
  final String recipientEmail;
  final String? targetUrl;
  final List<String>? pins;

  const Order({
    required this.id,
    required this.productName,
    required this.category,
    required this.date,
    required this.amount,
    required this.paymentStatus,
    required this.fulfilmentStatus,
    this.details,
    this.quantity = 1,
    this.recipientEmail = 'customer@example.com',
    this.targetUrl,
    this.pins,
  });

  DateTime get createdAt => date;
}

enum OrderPaymentStatus { paid, pending, failed }

enum OrderFulfilmentStatus { pending, processing, completed, cancelled }

/// Model representing a financial transaction record.
class Transaction {
  final String reference;
  final String description;
  final DateTime date;
  final double amount;
  final String paymentMethod;
  final TransactionStatus status;

  const Transaction({
    required this.reference,
    required this.description,
    required this.date,
    required this.amount,
    required this.paymentMethod,
    required this.status,
  });
}

enum TransactionStatus { successful, pending, failed }

/// Model representing an in-app notification.
class AppNotification {
  final String id;
  final String title;
  final String message;
  final DateTime date;
  final NotificationType type;
  final bool isRead;

  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
    required this.type,
    this.isRead = false,
  });
}

enum NotificationType { orderConfirmed, orderProcessing, orderCompleted, payment, support }

/// Model for FAQ items.
class FaqItem {
  final String question;
  final String answer;
  final String category;

  const FaqItem({
    required this.question,
    required this.answer,
    required this.category,
  });
}
