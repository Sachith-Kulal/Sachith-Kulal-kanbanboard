import 'dart:convert';

import 'package:get/get.dart';

import '../../../config.dart';
import '../../../domain/core/status/request_type.dart';
import '../../../domain/models/data_state/api_data_state.dart';
import '../../../domain/models/section_models/sections_response.dart';
import '../../../domain/utils/constants/api.dart';
import '../../../infrastructure/dal/daos/session_management.dart';
import '../../../infrastructure/dal/services/base_client.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final RxInt selectedIndex = 0.obs;
  final String profileName = "Sachith";
   int activeTimerTaskId = 0;

  Rx<ApiDataState<List<SectionResponse>>> sectionResponse =
      ApiDataState<List<SectionResponse>>.idle().obs;

  @override
  void onReady() {
    super.onReady();
     getSection();

  }

  @override
  void onClose() {
    super.onClose();
    selectedIndex.close();

  }

  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }

  getSection() async {
    sectionResponse.value = ApiDataState.loading();
    String projectId = await SessionManagement.getProjectId();
    await BaseClient.safeApiCall(
        '${ConfigEnvironments.getEnvironments()['url']!}${Api.sections}?project_id=$projectId',
        RequestType.get, onSuccess: (response) {
          print(response.statusCode);
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


}
