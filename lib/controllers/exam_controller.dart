import 'package:get/get.dart';
import '../data/models/exam_product.dart';
import '../data/mock/mock_data.dart';

/// Controller for the Examination E-Pins marketplace.
class ExamController extends GetxController {
  final products = <ExamProduct>[].obs;
  final filteredProducts = <ExamProduct>[].obs;
  final selectedCategory = 'All Products'.obs;
  final searchQuery = ''.obs;
  final selectedProduct = Rxn<ExamProduct>();
  final quantity = 1.obs;

  final categories = ['All Products', 'WAEC', 'NECO', 'NABTEB', 'Other Products'];

  @override
  void onInit() {
    super.onInit();
    products.assignAll(mockExamProducts);
    filteredProducts.assignAll(mockExamProducts);
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
    _applyFilters();
  }

  void search(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  void _applyFilters() {
    var result = products.toList();

    if (selectedCategory.value != 'All Products') {
      result = result.where((p) => p.category == selectedCategory.value).toList();
    }

    if (searchQuery.value.isNotEmpty) {
      final q = searchQuery.value.toLowerCase();
      result = result
          .where((p) =>
              p.name.toLowerCase().contains(q) ||
              p.provider.toLowerCase().contains(q) ||
              p.description.toLowerCase().contains(q))
          .toList();
    }

    filteredProducts.assignAll(result);
  }

  void selectProduct(ExamProduct product) {
    selectedProduct.value = product;
    quantity.value = 1;
  }

  void clearSelection() {
    selectedProduct.value = null;
    quantity.value = 1;
  }

  void incrementQuantity() {
    final max = selectedProduct.value?.maxQuantity ?? 10;
    if (quantity.value < max) {
      quantity.value++;
    }
  }

  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  void setQuantity(int qty) {
    final max = selectedProduct.value?.maxQuantity ?? 10;
    if (qty >= 1 && qty <= max) {
      quantity.value = qty;
    }
  }

  double get totalPrice => (selectedProduct.value?.price ?? 0) * quantity.value;
}
