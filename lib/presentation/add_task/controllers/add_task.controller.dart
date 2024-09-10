import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../config.dart';
import '../../../domain/core/status/button_status.dart';
import '../../../domain/core/status/request_type.dart';
import '../../../domain/core/views/custom_snackbar_view.dart';
import '../../../domain/models/data_state/api_data_state.dart';
import '../../../domain/models/priority_models/priority.dart';
import '../../../domain/models/section_models/sections_response.dart';
import '../../../domain/utils/constants/api.dart';
import '../../../domain/utils/constants/text_constants.dart';
import '../../../infrastructure/dal/daos/session_management.dart';
import '../../../infrastructure/dal/services/base_client.dart';

class AddTaskController extends GetxController {
  //TODO: Implement AddTaskController

  Rx<ButtonStatus> saveButton = ButtonStatus.enable.obs;

  Rx<ApiDataState<List<SectionResponse>>> sectionResponse =
      ApiDataState<List<SectionResponse>>.idle().obs;

  Rx<SectionResponse> selectedSection = SectionResponse().obs;
  Rx<Priority> selectedPriority = Priority().obs;
  Rx<ApiDataState<List<Priority>>> priority =
      ApiDataState<List<Priority>>.idle().obs;

  final TextEditingController contentCommentsController =
      TextEditingController();
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void onReady() {
    super.onReady();
    priority.value = ApiDataState.data(
        data: List<Priority>.from(
            TextConstants.priority.map((model) => Priority.fromJson(model))));
    selectedPriority.value = priority.value.data![0];
    getSection();
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
        selectedSection.value = sectionResponse.value.data!
            .where((section) => section.name == "To Do")
            .toList()
            .first;
      } else {
        sectionResponse.value = ApiDataState.error(message: 'No data');
      }
    }, onError: (error) {
      sectionResponse.value = ApiDataState.error(message: error.message);
    });
  }

  addTask() async {
    saveButton.value = ButtonStatus.loading;
    String projectId = await SessionManagement.getProjectId();
    Map<String, dynamic>? queryParameters = {
      "content": taskNameController.text.toString(),
      "description": descriptionController.text.toString(),
      "priority": selectedPriority.value.id.toString(),
      "section_id": selectedSection.value.id,
      "project_id": projectId
    };
    await BaseClient.safeApiCall(
        '${ConfigEnvironments.getEnvironments()['url']!}${Api.tasks}',
        queryParameters: queryParameters,
        RequestType.post, onSuccess: (response) {
      if (response.body.isNotEmpty) {
        descriptionController.text = "";
        taskNameController.text = "";
        selectedPriority.value = priority.value.data![0];
        selectedSection.value = sectionResponse.value.data!
            .where((section) => section.name == "To Do")
            .toList()
            .first;
        CustomSnackBarView.showCustomSuccessToast(message: "Task Added");
        saveButton.value = ButtonStatus.enable;
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
