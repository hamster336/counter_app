import 'package:counter_app/models/count.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class LocalStorage {
  static const String _countsBox = ('counts_box');

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(CountsAdapter());
    await Hive.openBox<Counts>(_countsBox);
  }

  static Future<void> saveCount(Counts data) async {
    final box = Hive.box<Counts>(_countsBox);
    await box.put(data.date, data);
  }

  static int getNumOfDays() {
    final box = Hive.box<Counts>(_countsBox);
    return box.length;
  }

  static int getCount(String time) {
    final box = Hive.box<Counts>(_countsBox);
    return box.get(time)?.count ?? 0;
  }
}
