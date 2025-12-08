import 'package:counter_app/models/count.dart';
import 'package:counter_app/models/count_controller.dart';
import 'package:counter_app/models/local_storage.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final controller = Get.find<CountController>();
  late List<Counts> data;
  bool start = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    data = LocalStorage.listOfCounts();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      await LocalStorage.saveCount(
        Counts(
          curCount: controller.currCount.value,
          dailyCount: controller.dailyCount.value,
          date: CountController.getTime(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final themeColor = Colors.cyan.shade400;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Counter',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ),

      body: GestureDetector(
        onTap: () {
          if (start) controller.increment();
        },
        child: ColoredBox(
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.02),

              Obx(() {
                return Text(
                  '${controller.currCount}',
                  style: TextStyle(fontSize: 65, fontWeight: FontWeight.w700),
                );
              }),

              SizedBox(height: size.height * 0.02),

              SizedBox(
                width: size.width,
                height: size.height * 0.3,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: Obx(() {
                    return LineChart(
                      LineChartData(
                        lineBarsData: [
                          LineChartBarData(spots: getSpot(data), barWidth: 3),
                        ],
                      ),
                    );
                  }),
                ),
              ).marginSymmetric(horizontal: 20),

              Spacer(),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // reset counting
                  IconButton(
                    onPressed: () {
                      Get.defaultDialog(
                        title: 'Reset Counter',
                        titleStyle: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                        middleText: '\tThe counter will be set to zero.\t',
                        middleTextStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                        barrierDismissible: false,
                        cancel: TextButton(
                          onPressed: () => Get.back(), // pop the dialog box
                          child: const Text(
                            'Cancel',
                            style: TextStyle(fontSize: 20, color: Colors.blue),
                          ),
                        ),
                        confirm: TextButton(
                          onPressed: () async {
                            Get.back(); // pop dialog box
                            controller.resetCount();
                            await LocalStorage.saveCount(
                              Counts(
                                curCount: controller.currCount.value,
                                dailyCount: controller.dailyCount.value,
                                date: CountController.getTime(),
                              ),
                            );
                          },
                          child: const Text(
                            'Yes',
                            style: TextStyle(fontSize: 20, color: Colors.red),
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.restore, size: 40),
                    style: IconButton.styleFrom(
                      backgroundColor: themeColor,
                      foregroundColor: Colors.black,
                    ),
                  ),

                  // start counting
                  IconButton(
                    onPressed: () {
                      Get.defaultDialog(
                        title: 'Start counting',
                        titleStyle: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                        ),
                        middleText: '\tThe counter can now be changed.\t',
                        middleTextStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                        barrierDismissible: false,
                        cancel: TextButton(
                          onPressed: () => Get.back(), // pop the dialog box
                          child: const Text(
                            'Cancel',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        confirm: TextButton(
                          onPressed: () {
                            Get.back(); // pop dialog box
                            start = true;
                          },
                          child: const Text(
                            'Start',
                            style: TextStyle(fontSize: 20, color: Colors.blue),
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.play_arrow, size: 40),
                    style: IconButton.styleFrom(
                      backgroundColor: themeColor,
                      foregroundColor: Colors.black,
                    ),
                  ),
                ],
              ).paddingSymmetric(horizontal: 25),

              SizedBox(height: size.height * 0.1),
            ],
          ),
        ),
      ),
    );
  }

  // get the spots to plot
  List<FlSpot> getSpot(List<Counts> data) {
    final List<FlSpot> list = [];

    for (var e in data) {
      final xAxis = double.parse(
        e.date.substring(e.date.length - 2),
      ); // last two characters from the string (day of the month)
      final yAxis = double.parse("${e.dailyCount}"); // count

      list.add(FlSpot(xAxis, yAxis));
    }

    final time = CountController.getTime();
    list.add(
      FlSpot(
        double.parse(time.substring(time.length - 2)),
        double.parse('${controller.dailyCount.value}'),
      ),
    );
    return list;
  }
}
