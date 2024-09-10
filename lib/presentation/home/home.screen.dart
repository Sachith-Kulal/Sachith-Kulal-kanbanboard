import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../domain/core/status/data_state_type.dart';
import '../../domain/core/views/custom_setting_dialog_box_view.dart';
import '../../infrastructure/navigation/routes.dart';
import 'controllers/home.controller.dart';
import 'views/all_view.dart';
import 'views/bottom_nav_bar_view.dart';
import 'views/completed_view.dart';
import 'views/done_view.dart';
import 'views/progress_view.dart';
import 'views/to_do_view.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.dialog(CustomSettingDialogBoxView());
                  },
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(
                      controller.profileName[0],
                      // Use the first letter of the profile name
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Spacing between the avatar and the text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "myProjectKananBoard".tr,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium, // Display the full profile name
                        // style: TextStyle(color: Colors.white),
                      ),
                      Obx(
                        () => Text(
                          controller.selectedIndex.value == 0
                              ? 'allTasks'.tr
                              : controller.selectedIndex.value == 1
                                  ? 'toDoTasks'.tr
                                  : controller.selectedIndex.value == 2
                                      ? 'progressTasks'.tr
                                      : controller.selectedIndex.value == 3
                                          ? 'doneTasks'.tr
                                          : 'completedTasks'.tr,
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: const Color(
                                  0xff37b8ff)), // Display the full profile name
                          // style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Obx(() {
          switch (controller.sectionResponse.value.type!) {
            case DataStateType.error:
              return Text(controller.sectionResponse.value.message!);
            case DataStateType.data:
              return Obx(() => [
                    AllView(
                      section: controller.sectionResponse.value.data!,
                      tab: controller.selectedIndex.value,
                    ),
                    ToDoView(section: controller.sectionResponse.value.data!),
                    ProgressView(
                        section: controller.sectionResponse.value.data!),
                    DoneView(section: controller.sectionResponse.value.data!),
                    const CompletedView()
                  ][controller.selectedIndex.value]);
            case DataStateType.idle:
              return const SizedBox();
            case DataStateType.loading:
              return const Center(
                child: CircularProgressIndicator(
                  value: null,
                  strokeWidth: 7.0,
                ),
              );
          }
        }),
        bottomNavigationBar: Obx(
          () => controller.sectionResponse.value.type! == DataStateType.data
              ? Obx(() {
                  return BottomNavBarView(
                      currentIndex: controller.selectedIndex.value,
                      onTap: controller.changeTabIndex);
                })
              : const SizedBox(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.toNamed(Routes.ADD_TASK)!.then((_) {
              controller.onReady();
            });
          },
          child: Text('+',
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: Theme.of(context)
                      .floatingActionButtonTheme
                      .foregroundColor)),
        ));
  }
}
