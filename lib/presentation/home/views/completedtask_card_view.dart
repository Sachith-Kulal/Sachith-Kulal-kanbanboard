import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../domain/core/views/priority_view.dart';
import '../../../domain/models/task_models/completed_task_response.dart';
import '../../../domain/utils/time_utils.dart';

class CompletedTaskCardView extends GetView {
  const CompletedTaskCardView({super.key, required this.task});

  final Item task;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListTile(
        title: Row(
          children: [
            Text(task.content!),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              task.itemObject!.description!,
              maxLines: 2,
            ),
            SizedBox(
              child: Row(
                children: [
                  Priority.getPriorityIcon(priorityType: 1),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(TimeUtils.getDisplayTime(
                      task.itemObject!.duration!.amount!,
                      task.itemObject!.duration!.unit!)),
                ],
              ),
            ),
            Text(
                'Created ${DateFormat('d MMMM yyyy \'at\' HH:mm').format(task.completedAt!)}'),
            Text(
                'completed ${DateFormat('d MMMM yyyy \'at\' HH:mm').format(task.itemObject!.addedAt!)}'),
          ],
        ),
      ),
    );
  }
}
