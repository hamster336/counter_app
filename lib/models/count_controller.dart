import 'package:counter_app/models/local_storage.dart';
import 'package:get/get.dart';

class CountController extends GetxController {
  var count = 0.obs;
  var startCount = false.obs;

  @override
  void onInit() {
    count.value = LocalStorage.getCount(getTime());
    super.onInit();
  }

  void increment() => count++;

  void decrement() => count--;

  void resetCount() => count.value = 0;

  static String getTime() {
    final date = DateTime.now();
    return '${date.year}${date.month}${date.day}${date.hour}';
  }
}
