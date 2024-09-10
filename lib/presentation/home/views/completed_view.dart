import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../domain/core/status/data_state_type.dart';

import '../controllers/task_controller.dart';
import 'completedtask_card_view.dart';

class CompletedView extends GetView<TaskController> {
  const CompletedView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.getCompletedTask();
    return SafeArea(child: Obx(() {
      return controller.completedTaskResponse.value.type == DataStateType.data
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 10),
                  itemCount: controller
                      .completedTaskResponse.value.data!.items!.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return CompletedTaskCardView(
                      task: controller
                          .completedTaskResponse.value.data!.items![index],
                    );
                  }),
            )
          : controller.completedTaskResponse.value.type == DataStateType.loading
              ? const Center(
                  child: CircularProgressIndicator(
                    value: null,
                    strokeWidth: 7.0,
                  ),
                )
              : Center(
                  child: Text(controller.completedTaskResponse.value.message!),
                );
    }));
  }
}
