import 'package:counter_app/models/local_storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CountController extends GetxController {
  var currCount = 0.obs;
  var dailyCount = 0.obs;
  var startCount = false.obs;

  @override
  void onInit() {
    currCount.value = LocalStorage.getCurrCount(getTime());
    dailyCount.value = LocalStorage.getDailyCount(getTime());
    super.onInit();
  }

  void increment() {
    currCount++;
    dailyCount++;
  }

  void resetCount() => currCount.value = 0;

  static String getTime() {
    final date = DateTime.now();
    return DateFormat('yyyy-MM-dd').format(date);
  }
}
