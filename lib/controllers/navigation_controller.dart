import 'package:get/get.dart';

/// Global navigation controller managing the current page index and navigation state.
class NavigationController extends GetxController {
  final currentIndex = 0.obs;
  final isDrawerOpen = false.obs;

  void changePage(int index) {
    currentIndex.value = index;
  }

  void toggleDrawer() {
    isDrawerOpen.value = !isDrawerOpen.value;
  }
}
