import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/exam_product.dart';
import '../models/social_service.dart';
import '../models/order.dart';

/// Mock examination e-pin products.
final List<ExamProduct> mockExamProducts = [
  const ExamProduct(
    id: 'waec-scratch-card',
    provider: 'WAEC',
    name: 'WAEC Scratch Card',
    description:
        'Original WAEC scratch card for result checking. Use this card to check your WASSCE results online.',
    price: 3500,
    category: 'WAEC',
  ),
  const ExamProduct(
    id: 'waec-registration-pin',
    provider: 'WAEC',
    name: 'WAEC Registration PIN',
    description:
        'Official WAEC registration PIN for WASSCE examination registration.',
    price: 18500,
    category: 'WAEC',
  ),
  const ExamProduct(
    id: 'waec-gce-registration',
    provider: 'WAEC',
    name: 'WAEC GCE Registration PIN',
    description:
        'WAEC GCE first series and second series registration PIN.',
    price: 22000,
    category: 'WAEC',
  ),
  const ExamProduct(
    id: 'neco-result-checker',
    provider: 'NECO',
    name: 'NECO Result Checker Token',
    description:
        'Official NECO token for checking your SSCE examination results online.',
    price: 1500,
    category: 'NECO',
  ),
  const ExamProduct(
    id: 'neco-registration-pin',
    provider: 'NECO',
    name: 'NECO Registration PIN',
    description:
        'NECO SSCE examination registration PIN for candidates.',
    price: 15000,
    category: 'NECO',
  ),
  const ExamProduct(
    id: 'neco-gce-registration',
    provider: 'NECO',
    name: 'NECO GCE Registration PIN',
    description:
        'NECO GCE external examination registration PIN.',
    price: 18000,
    category: 'NECO',
  ),
  const ExamProduct(
    id: 'nabteb-scratch-card',
    provider: 'NABTEB',
    name: 'NABTEB Scratch Card',
    description:
        'NABTEB result checker scratch card for technical examination results.',
    price: 1200,
    category: 'NABTEB',
  ),
  const ExamProduct(
    id: 'nabteb-registration',
    provider: 'NABTEB',
    name: 'NABTEB Registration PIN',
    description:
        'NABTEB examination registration PIN for May/June and November/December examinations.',
    price: 14500,
    category: 'NABTEB',
  ),
  const ExamProduct(
    id: 'jamb-e-pin',
    provider: 'JAMB',
    name: 'JAMB UTME e-PIN',
    description:
        'JAMB UTME registration e-PIN for university admission candidates.',
    price: 6700,
    category: 'Other Products',
    isAvailable: false,
  ),
  const ExamProduct(
    id: 'jamb-de-pin',
    provider: 'JAMB',
    name: 'JAMB Direct Entry e-PIN',
    description:
        'JAMB Direct Entry registration e-PIN for candidates with A-Level or equivalent qualifications.',
    price: 6700,
    category: 'Other Products',
    isAvailable: false,
  ),
];

/// Mock social media platforms.
final List<SocialPlatform> mockPlatforms = [
  const SocialPlatform(
    id: 'instagram',
    name: 'Instagram',
    icon: FontAwesomeIcons.instagram,
    color: Color(0xFFE4405F),
  ),
  const SocialPlatform(
    id: 'tiktok',
    name: 'TikTok',
    icon: FontAwesomeIcons.tiktok,
    color: Color(0xFF000000),
  ),
  const SocialPlatform(
    id: 'facebook',
    name: 'Facebook',
    icon: FontAwesomeIcons.facebook,
    color: Color(0xFF1877F2),
  ),
  const SocialPlatform(
    id: 'youtube',
    name: 'YouTube',
    icon: FontAwesomeIcons.youtube,
    color: Color(0xFFFF0000),
  ),
  const SocialPlatform(
    id: 'x',
    name: 'X (Twitter)',
    icon: FontAwesomeIcons.xTwitter,
    color: Color(0xFF000000),
  ),
];

/// Mock social media services.
final List<SocialService> mockSocialServices = [
  // Instagram
  const SocialService(
    id: 'ig-followers-1',
    platformId: 'instagram',
    name: 'Instagram Followers',
    description: 'High-quality Instagram followers for your profile. Gradual delivery for natural growth.',
    category: 'Followers',
    pricePerUnit: 5,
    minQuantity: 100,
    maxQuantity: 10000,
    estimatedDelivery: '1–3 days',
  ),
  const SocialService(
    id: 'ig-likes-1',
    platformId: 'instagram',
    name: 'Instagram Post Likes',
    description: 'Boost engagement on your Instagram posts with genuine-looking likes.',
    category: 'Likes',
    pricePerUnit: 2,
    minQuantity: 50,
    maxQuantity: 5000,
    estimatedDelivery: '0–24 hours',
  ),
  const SocialService(
    id: 'ig-views-1',
    platformId: 'instagram',
    name: 'Instagram Reels Views',
    description: 'Increase views on your Instagram Reels content.',
    category: 'Views',
    pricePerUnit: 1,
    minQuantity: 100,
    maxQuantity: 50000,
    estimatedDelivery: '0–12 hours',
  ),
  // TikTok
  const SocialService(
    id: 'tt-followers-1',
    platformId: 'tiktok',
    name: 'TikTok Followers',
    description: 'Grow your TikTok audience with real-looking followers.',
    category: 'Followers',
    pricePerUnit: 4,
    minQuantity: 100,
    maxQuantity: 10000,
    estimatedDelivery: '1–3 days',
  ),
  const SocialService(
    id: 'tt-likes-1',
    platformId: 'tiktok',
    name: 'TikTok Video Likes',
    description: 'Boost your TikTok video engagement with likes.',
    category: 'Likes',
    pricePerUnit: 2,
    minQuantity: 50,
    maxQuantity: 5000,
    estimatedDelivery: '0–24 hours',
  ),
  const SocialService(
    id: 'tt-views-1',
    platformId: 'tiktok',
    name: 'TikTok Video Views',
    description: 'Increase your TikTok video view count.',
    category: 'Views',
    pricePerUnit: 0.5,
    minQuantity: 500,
    maxQuantity: 100000,
    estimatedDelivery: '0–6 hours',
  ),
  // Facebook
  const SocialService(
    id: 'fb-followers-1',
    platformId: 'facebook',
    name: 'Facebook Page Followers',
    description: 'Grow your Facebook page audience.',
    category: 'Followers',
    pricePerUnit: 6,
    minQuantity: 100,
    maxQuantity: 10000,
    estimatedDelivery: '2–5 days',
  ),
  const SocialService(
    id: 'fb-likes-1',
    platformId: 'facebook',
    name: 'Facebook Post Likes',
    description: 'Increase likes on your Facebook posts.',
    category: 'Likes',
    pricePerUnit: 3,
    minQuantity: 50,
    maxQuantity: 5000,
    estimatedDelivery: '0–24 hours',
  ),
  // YouTube
  const SocialService(
    id: 'yt-subscribers-1',
    platformId: 'youtube',
    name: 'YouTube Subscribers',
    description: 'Build your YouTube subscriber count.',
    category: 'Followers',
    pricePerUnit: 15,
    minQuantity: 50,
    maxQuantity: 5000,
    estimatedDelivery: '3–7 days',
  ),
  const SocialService(
    id: 'yt-views-1',
    platformId: 'youtube',
    name: 'YouTube Video Views',
    description: 'Increase your YouTube video view count.',
    category: 'Views',
    pricePerUnit: 3,
    minQuantity: 100,
    maxQuantity: 50000,
    estimatedDelivery: '1–3 days',
  ),
  const SocialService(
    id: 'yt-likes-1',
    platformId: 'youtube',
    name: 'YouTube Video Likes',
    description: 'Boost your YouTube video with likes.',
    category: 'Likes',
    pricePerUnit: 5,
    minQuantity: 50,
    maxQuantity: 5000,
    estimatedDelivery: '0–24 hours',
  ),
  // X
  const SocialService(
    id: 'x-followers-1',
    platformId: 'x',
    name: 'X (Twitter) Followers',
    description: 'Grow your presence on X with followers.',
    category: 'Followers',
    pricePerUnit: 8,
    minQuantity: 100,
    maxQuantity: 10000,
    estimatedDelivery: '1–5 days',
  ),
  const SocialService(
    id: 'x-likes-1',
    platformId: 'x',
    name: 'X (Twitter) Post Likes',
    description: 'Increase likes on your posts.',
    category: 'Likes',
    pricePerUnit: 3,
    minQuantity: 50,
    maxQuantity: 5000,
    estimatedDelivery: '0–24 hours',
  ),
  const SocialService(
    id: 'x-views-1',
    platformId: 'x',
    name: 'X (Twitter) Post Views',
    description: 'Boost view counts on your X posts.',
    category: 'Views',
    pricePerUnit: 1,
    minQuantity: 100,
    maxQuantity: 50000,
    estimatedDelivery: '0–12 hours',
  ),
];

/// Mock orders for the dashboard.
final List<Order> mockOrders = [
  Order(
    id: 'ORD-2024-001',
    productName: 'WAEC Scratch Card',
    category: 'Examination E-Pins',
    date: DateTime(2024, 10, 15),
    amount: 3500,
    paymentStatus: OrderPaymentStatus.paid,
    fulfilmentStatus: OrderFulfilmentStatus.completed,
    details: 'WAEC scratch card for result checking. Serial: DEMO-XXXX-XXXX',
  ),
  Order(
    id: 'ORD-2024-002',
    productName: 'Instagram Followers (500)',
    category: 'Social Media Services',
    date: DateTime(2024, 10, 14),
    amount: 2500,
    paymentStatus: OrderPaymentStatus.paid,
    fulfilmentStatus: OrderFulfilmentStatus.processing,
    details: '500 Instagram followers delivery in progress.',
  ),
  Order(
    id: 'ORD-2024-003',
    productName: 'NECO Result Checker Token',
    category: 'Examination E-Pins',
    date: DateTime(2024, 10, 13),
    amount: 1500,
    paymentStatus: OrderPaymentStatus.paid,
    fulfilmentStatus: OrderFulfilmentStatus.completed,
    details: 'NECO result checker token delivered.',
  ),
  Order(
    id: 'ORD-2024-004',
    productName: 'TikTok Video Likes (1000)',
    category: 'Social Media Services',
    date: DateTime(2024, 10, 12),
    amount: 2000,
    paymentStatus: OrderPaymentStatus.pending,
    fulfilmentStatus: OrderFulfilmentStatus.pending,
    details: 'Awaiting payment confirmation.',
  ),
  Order(
    id: 'ORD-2024-005',
    productName: 'WAEC GCE Registration PIN',
    category: 'Examination E-Pins',
    date: DateTime(2024, 10, 10),
    amount: 22000,
    paymentStatus: OrderPaymentStatus.paid,
    fulfilmentStatus: OrderFulfilmentStatus.completed,
  ),
  Order(
    id: 'ORD-2024-006',
    productName: 'YouTube Video Views (5000)',
    category: 'Social Media Services',
    date: DateTime(2024, 10, 8),
    amount: 15000,
    paymentStatus: OrderPaymentStatus.failed,
    fulfilmentStatus: OrderFulfilmentStatus.cancelled,
    details: 'Payment failed. Order cancelled.',
  ),
];

/// Mock transactions.
final List<Transaction> mockTransactions = [
  Transaction(
    reference: 'TXN-20241015-001',
    description: 'WAEC Scratch Card Purchase',
    date: DateTime(2024, 10, 15),
    amount: 3500,
    paymentMethod: 'Bank Transfer',
    status: TransactionStatus.successful,
  ),
  Transaction(
    reference: 'TXN-20241014-002',
    description: 'Instagram Followers (500)',
    date: DateTime(2024, 10, 14),
    amount: 2500,
    paymentMethod: 'Card Payment',
    status: TransactionStatus.successful,
  ),
  Transaction(
    reference: 'TXN-20241013-003',
    description: 'NECO Result Checker Token',
    date: DateTime(2024, 10, 13),
    amount: 1500,
    paymentMethod: 'Bank Transfer',
    status: TransactionStatus.successful,
  ),
  Transaction(
    reference: 'TXN-20241012-004',
    description: 'TikTok Video Likes (1000)',
    date: DateTime(2024, 10, 12),
    amount: 2000,
    paymentMethod: 'Card Payment',
    status: TransactionStatus.pending,
  ),
  Transaction(
    reference: 'TXN-20241008-005',
    description: 'YouTube Video Views (5000)',
    date: DateTime(2024, 10, 8),
    amount: 15000,
    paymentMethod: 'Bank Transfer',
    status: TransactionStatus.failed,
  ),
];

/// Mock notifications.
final List<AppNotification> mockNotifications = [
  AppNotification(
    id: 'notif-1',
    title: 'Order Confirmed',
    message: 'Your order ORD-2024-001 for WAEC Scratch Card has been confirmed.',
    date: DateTime(2024, 10, 15, 14, 30),
    type: NotificationType.orderConfirmed,
  ),
  AppNotification(
    id: 'notif-2',
    title: 'Order Processing',
    message: 'Your Instagram Followers order ORD-2024-002 is being processed.',
    date: DateTime(2024, 10, 14, 10, 15),
    type: NotificationType.orderProcessing,
  ),
  AppNotification(
    id: 'notif-3',
    title: 'Order Completed',
    message: 'Your NECO Result Checker Token has been delivered. Check your orders for details.',
    date: DateTime(2024, 10, 13, 16, 45),
    type: NotificationType.orderCompleted,
  ),
  AppNotification(
    id: 'notif-4',
    title: 'Payment Update',
    message: 'Payment for TikTok Video Likes order is still pending. Please complete your payment.',
    date: DateTime(2024, 10, 12, 9, 0),
    type: NotificationType.payment,
    isRead: true,
  ),
  AppNotification(
    id: 'notif-5',
    title: 'Support Response',
    message: 'Our team has responded to your support ticket #SUP-001. Check your messages.',
    date: DateTime(2024, 10, 11, 11, 30),
    type: NotificationType.support,
    isRead: true,
  ),
];

/// Mock FAQ items.
const List<FaqItem> mockFaqItems = [
  FaqItem(
    question: 'How do I purchase an examination e-pin?',
    answer:
        'Simply browse our Examination E-Pins section, select the product you need (WAEC, NECO, NABTEB), choose the quantity, and proceed to checkout. Your e-pin will be delivered after payment confirmation.',
    category: 'Examination E-Pins',
  ),
  FaqItem(
    question: 'Are the examination scratch cards original?',
    answer:
        'Yes, all our examination products are sourced from authorised channels. Each pin is unique and valid for use on the respective examination body\'s portal.',
    category: 'Examination E-Pins',
  ),
  FaqItem(
    question: 'How long does delivery take for social media services?',
    answer:
        'Delivery times vary by service. Most services begin within a few hours, with full delivery ranging from a few hours to several days depending on the order size and service type. Estimated delivery is shown on each service card.',
    category: 'Social Media Services',
  ),
  FaqItem(
    question: 'Is it safe to use social media engagement services?',
    answer:
        'We use methods designed to appear natural and minimise risk. However, social media platforms may have their own policies regarding third-party engagement services. Please review the terms of service for each platform.',
    category: 'Social Media Services',
  ),
  FaqItem(
    question: 'How do I track my orders?',
    answer:
        'Log in to your RESOLVA account and visit the My Orders section in your dashboard. You can view the status of all your orders, including pending, processing, and completed orders.',
    category: 'Orders',
  ),
  FaqItem(
    question: 'What payment methods are accepted?',
    answer:
        'RESOLVA will support bank transfers and card payments. Payment options will be available at checkout once payment integration is complete.',
    category: 'Payments',
  ),
  FaqItem(
    question: 'How do I create an account?',
    answer:
        'Click the "Get Started" button on the homepage or navigate to the registration page. Fill in your full name, email address, phone number, and create a password to set up your account.',
    category: 'Customer Accounts',
  ),
  FaqItem(
    question: 'Can I get a refund?',
    answer:
        'Refund policies vary by product type. For examination e-pins, refunds are available if the pin has not been used. For social media services, refunds may be considered if the service was not delivered as described. Contact our support team for assistance.',
    category: 'Payments',
  ),
  FaqItem(
    question: 'When will CAC registration services be available?',
    answer:
        'CAC business registration services are currently being prepared and will be available soon. You can sign up for notifications on the CAC Registration page to be notified when the service launches.',
    category: 'CAC Registration',
  ),
  FaqItem(
    question: 'How do I contact support?',
    answer:
        'Visit the Help & Support section in your dashboard or the Contact Us page. You can submit a support form with your issue details and order reference, and our team will respond as soon as possible.',
    category: 'Customer Accounts',
  ),
];
