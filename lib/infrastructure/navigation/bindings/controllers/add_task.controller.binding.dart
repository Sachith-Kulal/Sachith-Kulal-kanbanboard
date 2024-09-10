import 'package:get/get.dart';

import '../../../../presentation/add_task/controllers/add_task.controller.dart';

class AddTaskControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddTaskController>(
      () => AddTaskController(),
    );
  }
}
