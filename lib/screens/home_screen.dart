import 'package:counter_app/models/count_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final controller = Get.find<CountController>();

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
        onTap: () => controller.increment(),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      Get.defaultDialog(
                        title: 'Reset Counter',
                        titleStyle: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                        middleText: 'The counter will be set to zero.',
                        middleTextStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                        barrierDismissible: false,
                        cancel: TextButton(
                          onPressed: () => Get.back(), // pop the dialog box
                          child: const Text(
                            'Cancel',
                            style: TextStyle(fontSize: 17, color: Colors.blue),
                          ),
                        ),
                        confirm: TextButton(
                          onPressed: () {
                            Get.back(); // pop dialog box
                            controller.resetCount();
                          },
                          child: const Text(
                            'Yes',
                            style: TextStyle(fontSize: 17, color: Colors.red),
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.restore, size: 40),
                    style: IconButton.styleFrom(backgroundColor: Colors.amber),
                  ),
                ],
              ).paddingSymmetric(horizontal: 20),

              SizedBox(height: size.height * 0.01),

              Obx(() {
                return Text(
                  '${controller.count}',
                  style: TextStyle(fontSize: 60, fontWeight: FontWeight.w700),
                );
              }),
              Text(
                '/ 108',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),

              Spacer(),
              SizedBox(
                width: size.width * 0.7,
                height: size.height * 0.2,
                child: Card(
                  elevation: 5,
                  child: Center(
                    child: Text(
                      'Malas Complete',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
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
