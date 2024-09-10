import 'package:get/get.dart';

import '../../../../presentation/edit_task/controllers/edit_task.controller.dart';

class EditTaskControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditTaskController>(
      () => EditTaskController(),
    );
  }
}
