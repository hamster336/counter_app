import 'dart:developer';

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

  static int getCurrCount(String time) {
    final box = Hive.box<Counts>(_countsBox);
    if (box.isNotEmpty) {
      return box.get(time)?.curCount ??
          box.getAt(box.length - 1)?.curCount ??
          0;
    } else {
      return 0;
    }
  }

  static int getDailyCount(String time) {
    final box = Hive.box<Counts>(_countsBox);
    return box.get(time)?.dailyCount ?? 0;
  }

  static bool hasKey(String today) {
    final box = Hive.box<Counts>(_countsBox);
    return box.containsKey(today);
  }

  static void getKeys() {
    final box = Hive.box<Counts>(_countsBox);
    final keys = box.keys.toList();
    for (var key in keys) {
      log(key);
    }
  }

  static void clear() async {
    final box = Hive.box<Counts>(_countsBox);
    await box.clear();
  }
}
