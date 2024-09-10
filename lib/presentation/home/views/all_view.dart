import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/core/status/data_state_type.dart';
import '../../../domain/models/section_models/sections_response.dart';
import '../../../infrastructure/navigation/routes.dart';
import '../controllers/task_controller.dart';
import 'task_item_view.dart';

class AllView extends GetView<TaskController> {
  const AllView({super.key, required this.section, required this.tab});

  final List<SectionResponse> section;
  final int tab;

  @override
  Widget build(BuildContext context) {
    controller.getAllTaskList(tab: 0);
    controller.section = section;
    return SafeArea(child: Obx(() {
      return controller.taskResponse.value.type == DataStateType.data
          ? Obx(() =>
              controller.closeTaskStatus.value.type == DataStateType.loading
                  ? const Center(
                      child: CircularProgressIndicator(
                        value: null,
                        strokeWidth: 7.0,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: ListView.separated(
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(height: 10),
                          itemCount: controller.taskResponse.value.data!.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return TaskItemView(
                              onTap: () {
                                Get.toNamed(Routes.EDIT_TASK,
                                        arguments: controller.taskResponse.value
                                            .data![index].id)!
                                    .then((_) {
                                  controller.onReady();
                                });
                              },
                              onMoveTask: controller.onMoveTask,
                              task: controller.taskResponse.value.data![index],
                              section: section,
                              onCompleted: (value) {
                                controller.taskResponse.value.data![index]
                                    .isCompleted.value = value!;
                                controller.closeTask(
                                    taskId: controller
                                        .taskResponse.value.data![index].id!);
                              },
                            );
                          }),
                    ))
          : controller.taskResponse.value.type == DataStateType.loading
              ? const Center(
                  child: CircularProgressIndicator(
                    value: null,
                    strokeWidth: 7.0,
                  ),
                )
              : Center(
                  child: Text(controller.taskResponse.value.message!),
                );
    }));
  }
}
