import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../domain/core/views/custom_check_box_view.dart';
import '../../../domain/core/views/priority_view.dart';
import '../../../domain/models/section_models/sections_response.dart';
import '../../../domain/models/task_models/task_response_model.dart';
import '../../../domain/utils/time_utils.dart';
import '../controllers/timer_controller.dart';

class TaskItemView extends GetView<TimerController> {
  const TaskItemView(
      {super.key,
      required this.task,
      required this.section,
      required this.onMoveTask,
      required this.onCompleted,
      required this.onTap});

  final TaskResponse task;
  final List<SectionResponse> section;

  final void Function(String, String) onMoveTask;
  final void Function(bool?) onCompleted;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(left: 12, right: 16),
      child: ListTile(
        title: Text(task.content!),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              task.description!,
              maxLines: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  child: Row(
                    children: [
                      Obx(() {
                        return CustomCheckBoxView(
                          value: task.isCompleted.value,
                          onChanged: onCompleted,
                          borderColor: Priority.getPriorityColor(
                              priorityType: task.priority!),
                        );
                      }),
                      const SizedBox(
                        width: 8,
                      ),
                      Priority.getPriorityIcon(priorityType: task.priority!,size: 20),
                      const SizedBox(
                        width: 8,
                      ),
                      Obx(() {
                        return Text(TimeUtils.getDisplayTime(
                            controller.isTimerActive.value &&
                                    controller.timerTaskId == task.id
                                ? controller.counter.value
                                : task.duration!.amount!,
                            task.duration!.unit!),style: const TextStyle(fontSize: 16),);
                      }),
                    ],
                  ),
                ),
                Obx(() {
                  return controller.isTimerActive.value &&
                          controller.timerTaskId == task.id
                      ? GestureDetector(
                          child: const Icon(Icons.stop_circle),
                          onTap: () {
                            task.duration!.amount = controller.counter.value;
                            controller.stopTimer();
                            },
                        )
                      : GestureDetector(
                          child: const Icon(Icons.play_circle),
                          onTap: () {
                            controller.startTimer(
                                task.id!, task.duration!.amount!);
                          },
                        );
                }),
                PopupMenuButton<SectionResponse>(
                  child: Container(
                      decoration: BoxDecoration(
                        // color: Colors.white,
                        border: Border.all(
                          color: Theme.of(context).primaryColorLight,
                          width: 1.0, // Outline width
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16, right: 8),
                        child: Row(
                          children: [
                            Text(
                              task.sectionId == null
                                  ? "To Do"
                                  : section
                                      .where((section1) =>
                                          section1.id == task.sectionId)
                                      .toList()
                                      .first
                                      .name!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    fontSize: 12,
                                  ),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: Theme.of(context).primaryColorLight,
                            ),
                          ],
                        ),
                      )),
                  onSelected: (value) {
                    onMoveTask(value.id!, task.id!);
                    // Handle status change
                  },
                  itemBuilder: (context) =>
                      section.map((SectionResponse section) {
                    return PopupMenuItem<SectionResponse>(
                      value: section,
                      child: Text(section.name!),
                    );
                  }).toList(),
                )
              ],
            )
          ],
        ),
        // trailing: ,
        onTap: onTap,
      ),
    );
  }
}
