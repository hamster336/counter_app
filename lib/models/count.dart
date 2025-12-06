import 'package:hive_ce/hive.dart';

part 'count.g.dart';

@HiveType(typeId: 0)
class Counts extends HiveObject{
  @HiveField(0) late int count;
  @HiveField(1) late String date;

  Counts({
    required this.count,
    required this.date
  });
}