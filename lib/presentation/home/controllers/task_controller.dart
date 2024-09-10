import 'dart:convert';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../config.dart';
import '../../../domain/core/status/request_type.dart';
import '../../../domain/core/views/custom_snackbar_view.dart';
import '../../../domain/models/data_state/api_data_state.dart';
import '../../../domain/models/section_models/sections_response.dart';
import '../../../domain/models/task_models/completed_task_response.dart';
import '../../../domain/models/task_models/task_response_model.dart';
import '../../../domain/utils/constants/api.dart';
import '../../../infrastructure/dal/daos/session_management.dart';
import '../../../infrastructure/dal/services/base_client.dart';

class TaskController extends GetxController {
  //TODO: Implement TaskController
  Rx<ApiDataState<List<TaskResponse>>> taskResponse =
      ApiDataState<List<TaskResponse>>.idle().obs;
  List<SectionResponse> section = [];
  Rx<ApiDataState> closeTaskStatus = ApiDataState.idle().obs;




  Rx<ApiDataState<CompletedTaskResponse>> completedTaskResponse =
      ApiDataState<CompletedTaskResponse>.idle().obs;

   int tab =0;



  getAllTaskList({required int tab}) async {

    tab = tab;
    taskResponse.value = ApiDataState.loading();
    String projectId = await SessionManagement.getProjectId();
    String sectionId = getSectionId(tab: tab);

    await BaseClient.safeApiCall(
        '${ConfigEnvironments.getEnvironments()['url']!}${Api.tasks}?project_id=$projectId$sectionId',
        RequestType.get, onSuccess: (response) {
      if (response.body.isNotEmpty) {
        taskResponse.value = ApiDataState.data(
            data: List<TaskResponse>.from(jsonDecode(response.body)
                .map((model) => TaskResponse.fromJson(model))));
      } else {
        taskResponse.value = ApiDataState.error(message: 'No data');
      }
    }, onError: (error) {
      taskResponse.value = ApiDataState.error(message: error.message);
    });
  }

  void onMoveTask(String sectionID, String taskID) async {
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
        getAllTaskList(tab: tab);
        String? name = section.where((item) => item.id == sectionID).toList().first.name;
        CustomSnackBarView.showCustomSuccessToast(
            message: "Task moved to ${name??""}");
      } else {
        CustomSnackBarView.showCustomErrorToast(
            message: "Something went wrong. Try again in a few minutes");
      }
    }, onError: (error) {
      CustomSnackBarView.showCustomErrorToast(message: error.message);
    });
  }

  String getSectionId({required int tab}) {
    return tab == 0
        ? ""
        : tab == 1
            ? "&section_id=${section.where((section) => section.name == "To Do").toList().first.id!}"
            : tab == 2
                ? "&section_id=${section.where((section) => section.name == "Progress").toList().first.id!}"
                : "&section_id=${section.where((section) => section.name == "Done").toList().first.id!}";
  }

  void getCompletedTask() async {
    completedTaskResponse.value = ApiDataState.loading();
    String projectId = await SessionManagement.getProjectId();

    await BaseClient.safeApiCall(
        '${ConfigEnvironments.getEnvironments()['urlSync']}${Api.completed}?annotate_items=true&project_id=$projectId',
        header: {
          'Content-Type': 'application/json',
        },
        RequestType.get, onSuccess: (response) {
      if (response.body.isNotEmpty) {
        completedTaskResponse.value = ApiDataState.data(
            data: CompletedTaskResponse.fromJson(jsonDecode(response.body)));
      } else {
        completedTaskResponse.value = ApiDataState.error(message: 'No data');
      }
    }, onError: (error) {
      completedTaskResponse.value = ApiDataState.error(message: error.message);
    });
  }

  closeTask({required String taskId}) async {
    closeTaskStatus.value = ApiDataState.loading();
    await BaseClient.safeApiCall(
        '${ConfigEnvironments.getEnvironments()['url']!}${Api.tasks}/$taskId/close',
        RequestType.post, onSuccess: (response) {
      if (response.statusCode ==204) {
        getAllTaskList(tab: tab);
        CustomSnackBarView.showCustomSuccessToast(message: "Task completed");
        closeTaskStatus.value = ApiDataState.idle();

      } else {
        CustomSnackBarView.showCustomErrorToast(message: "Something went wrong. Try again in a few minutes");
        closeTaskStatus.value = ApiDataState.loading();
      }
    }, onError: (error) {
      CustomSnackBarView.showCustomErrorToast(message: error.message);
      closeTaskStatus.value = ApiDataState.loading();
    });
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    getAllTaskList(tab: tab);
  }
}
