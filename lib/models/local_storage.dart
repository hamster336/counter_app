import 'dart:developer';

import 'package:counter_app/models/count.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class LocalStorage {
  static const String _countsBox = ('counts_box');

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(CountsAdapter());
    await Hive.openBox<Counts>(_countsBox);
  }

  // save counts
  static Future<void> saveCount(Counts data) async {
    final box = Hive.box<Counts>(_countsBox);
    await box.put(data.date, data);
  }

  // get the currCount to be displayed
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

  // get the daily count
  static int getDailyCount(String time) {
    final box = Hive.box<Counts>(_countsBox);
    return box.get(time)?.dailyCount ?? 0;
  }

  // get the keys from hive
  static void getKeys() {
    final box = Hive.box<Counts>(_countsBox);
    final keys = box.keys.toList();
    for (var key in keys) {
      log(key);
    }
  }

  // get a list for the graph
  static List<Counts> listOfCounts(){
    final box = Hive.box<Counts>(_countsBox);
    final List<Counts> result = [];
    final today = DateTime.now();

    for(int i=6; i>=0; i--){
      final date = today.subtract(Duration(days: i));
      final dateKey = DateFormat('yyyy-MM-dd').format(date);

      if(box.containsKey(dateKey)){
        result.add(box.get(dateKey)!);
      }else{
        result.add(Counts(curCount: 0, dailyCount: 0, date: dateKey));
      }
    }

    return result;
  }
}
