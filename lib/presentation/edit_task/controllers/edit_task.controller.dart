import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../config.dart';
import '../../../domain/core/status/button_status.dart';
import '../../../domain/core/status/request_type.dart';
import '../../../domain/core/views/custom_snackbar_view.dart';
import '../../../domain/models/comment_models/comments_response.dart';
import '../../../domain/models/data_state/api_data_state.dart';
import '../../../domain/models/priority_models/priority.dart';
import '../../../domain/models/section_models/sections_response.dart';
import '../../../domain/models/task_models/task_response_model.dart';
import '../../../domain/utils/constants/api.dart';
import '../../../domain/utils/constants/text_constants.dart';
import '../../../infrastructure/dal/daos/session_management.dart';
import '../../../infrastructure/dal/services/base_client.dart';

class EditTaskController extends GetxController {
  //TODO: Implement EditTaskController

  Rx<ButtonStatus> saveButton = ButtonStatus.enable.obs;
  Rx<ButtonStatus> saveCommentButton = ButtonStatus.enable.obs;

  Rx<ApiDataState<TaskResponse>> taskResponse =
      ApiDataState<TaskResponse>.idle().obs;

  Rx<ApiDataState<List<SectionResponse>>> sectionResponse =
      ApiDataState<List<SectionResponse>>.idle().obs;

  Rx<ApiDataState<List<CommentsResponse>>> commentsResponse =
      ApiDataState<List<CommentsResponse>>.idle().obs;

  Rx<SectionResponse> selectedSection = SectionResponse().obs;
  Rx<Priority> selectedPriority = Priority().obs;
  Rx<ApiDataState<List<Priority>>> priority =
      ApiDataState<List<Priority>>.idle().obs;

  final TextEditingController contentCommentsController =
      TextEditingController();
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  late String lastSectionId;

  @override
  void onReady() async {
    priority.value = ApiDataState.data(
        data: List<Priority>.from(
            TextConstants.priority.map((model) => Priority.fromJson(model))));
    selectedPriority.value = priority.value.data![0];
    super.onReady();
  }

  getTaskInfo({required String taskId}) async {
    taskResponse.value = ApiDataState.loading();
    await getSection();

    await BaseClient.safeApiCall(
        '${ConfigEnvironments.getEnvironments()['url']!}${Api.tasks}/$taskId',
        RequestType.get, onSuccess: (response) {
      if (response.body.isNotEmpty) {

        taskResponse.value = ApiDataState.data(
            data: TaskResponse.fromJson(jsonDecode(response.body)));
        selectedPriority.value = priority.value.data!
            .where(
                (priority) => priority.id == taskResponse.value.data!.priority!)
            .toList()
            .first;
        selectedSection.value = sectionResponse.value.data!
            .where(
                (section) => section.id == taskResponse.value.data!.sectionId!)
            .toList()
            .first;
        lastSectionId = taskResponse.value.data!.sectionId!;
        descriptionController.text = taskResponse.value.data!.description!;
        taskNameController.text = taskResponse.value.data!.content!;
      } else {
        taskResponse.value = ApiDataState.error(message: 'No data');
      }
    }, onError: (error) {
          print(error);
      taskResponse.value = ApiDataState.error(message: error.message);
    });
  }

  getSection() async {
    sectionResponse.value = ApiDataState.loading();
    String projectId = await SessionManagement.getProjectId();
    await BaseClient.safeApiCall(
        '${ConfigEnvironments.getEnvironments()['url']!}${Api.sections}?project_id=$projectId',
        RequestType.get, onSuccess: (response) {
      if (response.body.isNotEmpty) {
        sectionResponse.value = ApiDataState.data(
            data: List<SectionResponse>.from(jsonDecode(response.body)
                .map((model) => SectionResponse.fromJson(model))));
      } else {
        sectionResponse.value = ApiDataState.error(message: 'No data');
      }
    }, onError: (error) {
      sectionResponse.value = ApiDataState.error(message: error.message);
    });
  }

  getComments({required String taskId}) async {
    commentsResponse.value = ApiDataState.loading();
    await BaseClient.safeApiCall(
        '${ConfigEnvironments.getEnvironments()['url']!}${Api.comments}?task_id=$taskId',
        RequestType.get, onSuccess: (response) {
      if (response.body.isNotEmpty) {
        commentsResponse.value = ApiDataState.data(
            data: List<CommentsResponse>.from(jsonDecode(response.body)
                .map((model) => CommentsResponse.fromJson(model))));
      } else {
        commentsResponse.value = ApiDataState.error(message: 'No data');
      }
    }, onError: (error) {
      commentsResponse.value = ApiDataState.error(message: error.message);
    });
  }

  updateComments({required String taskId}) async {
    saveCommentButton.value = ButtonStatus.loading;
    Map<String, dynamic>? queryParameters = {
      "task_id": taskId,
      "content": contentCommentsController.text.toString()
    };
    await BaseClient.safeApiCall(
        '${ConfigEnvironments.getEnvironments()['url']!}${Api.comments}',
        queryParameters: queryParameters,
        RequestType.post, onSuccess: (response) {
      if (response.body.isNotEmpty) {
        contentCommentsController.text = "";
        getComments(taskId: taskId);
        saveCommentButton.value = ButtonStatus.enable;
      } else {
        saveCommentButton.value = ButtonStatus.enable;
        CustomSnackBarView.showCustomSuccessToast(
            message: "Something went wrong. Try again in a few minutes");
      }
    }, onError: (error) {
      saveCommentButton.value = ButtonStatus.enable;
      CustomSnackBarView.showCustomSuccessToast(message: error.message);
    });
  }

  updateTaskId({required String taskId}) async {
    saveButton.value = ButtonStatus.loading;
    Map<String, dynamic>? queryParameters = {
      "content": taskNameController.text.toString(),
      "description": descriptionController.text.toString(),
      "priority": selectedPriority.value.id.toString()
    };
    await BaseClient.safeApiCall(
        '${ConfigEnvironments.getEnvironments()['url']!}${Api.tasks}/$taskId',
        queryParameters: queryParameters,
        RequestType.post, onSuccess: (response) {
      if (response.body.isNotEmpty) {
        descriptionController.text = "";
        taskNameController.text = "";
        if (lastSectionId == selectedSection.value.id) {
          getTaskInfo(taskId: taskId);
          getComments(taskId: taskId);
          saveButton.value = ButtonStatus.enable;
        } else {
          onMoveTask(sectionID: selectedSection.value.id!, taskID: taskId);
        }
      } else {
        saveButton.value = ButtonStatus.enable;
        CustomSnackBarView.showCustomErrorToast(
            message: "Something went wrong. Try again in a few minutes");
      }
    }, onError: (error) {
      saveButton.value = ButtonStatus.enable;
      CustomSnackBarView.showCustomErrorToast(message: error.message);
    });
  }

  void onMoveTask({required String sectionID, required String taskID}) async {
    var uuid = const Uuid();
    final body = jsonEncode({
      "commands": [
        {
          "type": "item_move",
          "uuid": uuid.v4(),
          "args": {"id": taskID, "section_id": sectionID}
        }
      ]
    });
    await BaseClient.safeApiCall(
        '${ConfigEnvironments.getEnvironments()['urlSync']}${Api.sync}',
        queryParameters: body,
        header: {
          'Content-Type': 'application/json',
        },
        RequestType.post, onSuccess: (response) {
      if (response.body.isNotEmpty) {
        lastSectionId = sectionID;
        saveButton.value = ButtonStatus.enable;
        getTaskInfo(taskId: taskID);
        getComments(taskId: taskID);
      } else {
        saveButton.value = ButtonStatus.enable;
        CustomSnackBarView.showCustomErrorToast(
            message: "Something went wrong. Try again in a few minutes");
      }
    }, onError: (error) {
      saveButton.value = ButtonStatus.enable;
      CustomSnackBarView.showCustomErrorToast(message: error.message);
    });
  }
}
