import 'package:get/get.dart';
import '../data/models/social_service.dart';
import '../data/mock/mock_data.dart';

/// Controller for the Social Media Services marketplace.
class SocialController extends GetxController {
  final platforms = mockPlatforms;
  final services = <SocialService>[].obs;
  final filteredServices = <SocialService>[].obs;
  final selectedPlatformId = ''.obs;
  final selectedCategory = 'All'.obs;
  final selectedService = Rxn<SocialService>();
  final quantity = 0.obs;
  final profileUrl = ''.obs;

  final categories = ['All', 'Followers', 'Likes', 'Views'];

  @override
  void onInit() {
    super.onInit();
    services.assignAll(mockSocialServices);
    filteredServices.assignAll(mockSocialServices);
  }

  void selectPlatform(String platformId) {
    if (selectedPlatformId.value == platformId) {
      selectedPlatformId.value = '';
    } else {
      selectedPlatformId.value = platformId;
    }
    selectedCategory.value = 'All';
    _applyFilters();
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
    _applyFilters();
  }

  void _applyFilters() {
    var result = services.toList();

    if (selectedPlatformId.value.isNotEmpty) {
      result = result.where((s) => s.platformId == selectedPlatformId.value).toList();
    }

    if (selectedCategory.value != 'All') {
      result = result.where((s) => s.category == selectedCategory.value).toList();
    }

    filteredServices.assignAll(result);
  }

  void selectService(SocialService service) {
    selectedService.value = service;
    quantity.value = service.minQuantity;
    profileUrl.value = '';
  }

  void clearSelection() {
    selectedService.value = null;
    quantity.value = 0;
    profileUrl.value = '';
  }

  void setQuantity(int qty) {
    final service = selectedService.value;
    if (service == null) return;
    if (qty >= service.minQuantity && qty <= service.maxQuantity) {
      quantity.value = qty;
    }
  }

  void incrementQuantity([int step = 100]) {
    final service = selectedService.value;
    if (service == null) return;
    final newQty = quantity.value + step;
    if (newQty <= service.maxQuantity) {
      quantity.value = newQty;
    } else {
      quantity.value = service.maxQuantity;
    }
  }

  void decrementQuantity([int step = 100]) {
    final service = selectedService.value;
    if (service == null) return;
    final newQty = quantity.value - step;
    if (newQty >= service.minQuantity) {
      quantity.value = newQty;
    } else {
      quantity.value = service.minQuantity;
    }
  }

  void setProfileUrl(String url) {
    profileUrl.value = url;
  }

  double get totalPrice {
    final service = selectedService.value;
    if (service == null) return 0;
    return service.pricePerUnit * quantity.value;
  }

  SocialPlatform? get selectedPlatform {
    if (selectedPlatformId.value.isEmpty) return null;
    try {
      return platforms.firstWhere((p) => p.id == selectedPlatformId.value);
    } catch (_) {
      return null;
    }
  }
}
