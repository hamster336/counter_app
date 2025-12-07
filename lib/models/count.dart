import 'package:hive_ce/hive.dart';

part 'count.g.dart';

@HiveType(typeId: 0)
class Counts extends HiveObject {
  @HiveField(0)
  late int curCount;
  @HiveField(1)
  late int dailyCount;
  @HiveField(2)
  late String date;

  Counts({
    required this.curCount,
    required this.dailyCount,
    required this.date,
  });
}
