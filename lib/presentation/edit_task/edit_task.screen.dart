import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../domain/core/status/data_state_type.dart';
import '../../domain/core/views/custom_button_view.dart';
import '../../domain/core/views/priority_view.dart' as priority_view;
import '../../domain/models/priority_models/priority.dart';
import '../../domain/models/section_models/sections_response.dart';
import 'controllers/edit_task.controller.dart';

class EditTaskScreen extends GetView<EditTaskController> {
  const EditTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String taskId = Get.arguments as String;
    controller.getTaskInfo(taskId: taskId);
    controller.getComments(taskId: taskId);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leadingWidth: 40,
        elevation: 1,
        title: Text(
          'editAndCommentTask'.tr,
          maxLines: 2,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() {
              switch (controller.taskResponse.value.type!) {
                case DataStateType.data:
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    child: Column(
                      children: [
                        TextFormField(
                            maxLines: 2,
                            controller: controller.taskNameController,
                            keyboardType: TextInputType.multiline,
                            decoration: const InputDecoration().copyWith(
                              hintText: 'taskName'.tr,
                              // labelText: "ddd",
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                            maxLines: 4,
                            controller: controller.descriptionController,
                            keyboardType: TextInputType.multiline,
                            decoration: const InputDecoration().copyWith(
                              hintText: 'description'.tr,
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: PopupMenuButton<SectionResponse>(
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .inputDecorationTheme
                                          .fillColor,
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .inputDecorationTheme
                                            .border!
                                            .borderSide
                                            .color,
                                        width: Theme.of(context)
                                            .inputDecorationTheme
                                            .border!
                                            .borderSide
                                            .width, // Outline width
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16,
                                          right: 8,
                                          top: 8,
                                          bottom: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Obx(() {
                                            return Text(
                                              controller
                                                  .selectedSection.value.name!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                    fontSize: 12,
                                                  ),
                                            );
                                          }),
                                          const Icon(
                                            Icons.arrow_drop_down,
                                          ),
                                        ],
                                      ),
                                    )),
                                onSelected: (value) {
                                  controller.selectedSection.value = value;
                                },
                                itemBuilder: (context) => controller
                                    .sectionResponse.value.data!
                                    .map((SectionResponse section) {
                                  return PopupMenuItem<SectionResponse>(
                                    value: section,
                                    child: Text(section.name!),
                                  );
                                }).toList(),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: PopupMenuButton<Priority>(
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .inputDecorationTheme
                                          .fillColor,
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .inputDecorationTheme
                                            .border!
                                            .borderSide
                                            .color,
                                        width: Theme.of(context)
                                            .inputDecorationTheme
                                            .border!
                                            .borderSide
                                            .width, // Outline width
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16,
                                          right: 8,
                                          top: 8,
                                          bottom: 8),
                                      child: Obx(() {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            priority_view.Priority
                                                .getPriorityIcon(
                                                    priorityType: controller
                                                        .selectedPriority
                                                        .value
                                                        .id!),
                                            Text(controller
                                                .selectedPriority.value.text!),
                                            const Icon(
                                              Icons.arrow_drop_down,
                                            ),
                                          ],
                                        );
                                      }),
                                    )),
                                onSelected: (value) {
                                  controller.selectedPriority.value = value;
                                },
                                itemBuilder: (context) => controller
                                    .priority.value.data!
                                    .map((Priority priority) {
                                  return PopupMenuItem<Priority>(
                                    value: priority,
                                    child: ListTile(
                                      leading: priority_view.Priority
                                          .getPriorityIcon(
                                              priorityType: priority.id!),
                                      title: Text(priority.text!),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: CustomButtonView(
                                onPressed: () {
                                  controller.updateTaskId(taskId: taskId);
                                },
                                fontSize: 20,
                                text: "save".tr,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                case DataStateType.error:
                  return Center(
                    child: Text(controller.taskResponse.value.message!),
                  );
                case DataStateType.loading:
                  return const SizedBox(
                    height: 100,
                    child: Center(
                        child: CircularProgressIndicator(
                      value: null,
                      strokeWidth: 7.0,
                    )),
                  );
                case DataStateType.idle:
                  return const SizedBox();
              }
            }),
            Container(height: 2, color: Colors.grey[200]),
            Obx(() {
              switch (controller.commentsResponse.value.type!) {
                case DataStateType.data:
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          color: Theme.of(context)
                              .inputDecorationTheme
                              .border!
                              .borderSide
                              .color,
                          width: Theme.of(context)
                              .inputDecorationTheme
                              .border!
                              .borderSide
                              .width, // Outline width
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ExpansionTile(
                        shape: const Border(),
                        title: Text('comments'.tr,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    fontSize: 18, fontWeight: FontWeight.w500)),
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(
                                  color: Theme.of(context)
                                      .inputDecorationTheme
                                      .border!
                                      .borderSide
                                      .color,
                                  width: Theme.of(context)
                                      .inputDecorationTheme
                                      .border!
                                      .borderSide
                                      .width, // Outline width
                                ),
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 16),
                              child: Column(
                                children: [
                                  TextFormField(
                                      maxLines: 2,
                                      controller:
                                          controller.contentCommentsController,
                                      keyboardType: TextInputType.multiline,
                                      decoration:
                                          const InputDecoration().copyWith(
                                        hintText: 'comment'.tr,
                                      )),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CustomButtonView(
                                          onPressed: () {
                                            controller.updateComments(
                                                taskId: taskId);
                                          },
                                          text: 'saveComment'.tr,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          controller.commentsResponse.value.data!.isEmpty
                              ? const SizedBox(
                                  height: 0,
                                )
                              : Column(
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16,
                                          right: 16,
                                          top: 0,
                                          bottom: 16),
                                      child: ListView.separated(
                                          physics: const NeverScrollableScrollPhysics(),
                                          separatorBuilder:
                                              (BuildContext context,
                                                      int index) =>
                                                  const Divider(height: 10),
                                          itemCount: controller.commentsResponse
                                              .value.data!.length,
                                          shrinkWrap: true,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return SizedBox(
                                              child: Row(
                                                children: [
                                                  const CircleAvatar(
                                                    radius: 15,
                                                    backgroundColor:
                                                        Colors.blue,
                                                    child: Text(
                                                      'S',
                                                      // Use the first letter of the profile name
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text("Sachith",
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleLarge!
                                                                  .copyWith(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500)),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 16),
                                                            child: Text(
                                                                DateFormat(
                                                                        'd MMMM yyyy \'at\' HH:mm')
                                                                    .format(controller
                                                                        .commentsResponse
                                                                        .value
                                                                        .data![
                                                                            index]
                                                                        .postedAt!),
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .titleLarge!
                                                                    .copyWith(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w300)),
                                                          )
                                                        ],
                                                      ),
                                                      Text(controller
                                                          .commentsResponse
                                                          .value
                                                          .data![index]
                                                          .content!),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                    ),
                                  ],
                                )
                        ],
                      ),
                    ),
                  );
                case DataStateType.error:
                  return Center(
                    child: Text(controller.commentsResponse.value.message!),
                  );
                case DataStateType.loading:
                  return const SizedBox(
                    height: 50,
                    child: Center(
                        child: CircularProgressIndicator(
                      value: null,
                      strokeWidth: 7.0,
                    )),
                  );
                case DataStateType.idle:
                  return const SizedBox();
              }
            }),
          ],
        ),
      ),
    );
  }
}
