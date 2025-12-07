import 'dart:developer';

import 'package:counter_app/models/count.dart';
import 'package:counter_app/models/count_controller.dart';
import 'package:counter_app/models/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final controller = Get.find<CountController>();
  bool start = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // elevation: 3,
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
          if (start) {
            controller.increment();
            controller.incrementDaily();
          }
        },
        child: ColoredBox(
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                    ),
                  ),

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
                          onPressed: () {
                            Get.back(); // pop dialog box
                            controller.resetCount();
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
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                    ),
                  ),
                ],
              ).paddingSymmetric(horizontal: 20),

              SizedBox(height: size.height * 0.01),

              Obx(() {
                return Text(
                  '${controller.currCount}',
                  style: TextStyle(fontSize: 65, fontWeight: FontWeight.w700),
                );
              }),

              Spacer(),
              SizedBox(
                width: size.width * 0.7,
                height: size.height * 0.2,
                child: InkWell(
                  onTap: () {
                    final time = CountController.getTime();
                    LocalStorage.getKeys();
                    log(
                      'current: ${controller.currCount.value} daily: ${controller.dailyCount.value}',
                    );
                  },
                  child: Card(
                    elevation: 5,
                    child: Center(
                      child: Text(
                        'Graph',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Spacer(),

              Container(
                width: size.width * 0.65,
                height: size.height * 0.055,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 246, 249, 181),
                  borderRadius: BorderRadius.circular(35),
                ),
                child: Center(
                  child: Text(
                    'Tap Anywhere to count',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.15),
            ],
          ),
        ),
      ),
    );
  }
}
