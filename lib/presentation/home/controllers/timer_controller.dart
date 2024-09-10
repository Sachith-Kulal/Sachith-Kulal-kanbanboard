import 'dart:async';

import 'package:get/get.dart';

import '../../../config.dart';
import '../../../domain/core/status/request_type.dart';
import '../../../domain/core/views/custom_snackbar_view.dart';
import '../../../domain/utils/constants/api.dart';
import '../../../infrastructure/dal/daos/session_management.dart';
import '../../../infrastructure/dal/services/base_client.dart';

class TimerController extends GetxController {
  //TODO: Implement TimerController

  Timer? _timer;

  String timerTaskId = "";
  RxInt counter = 0.obs;
  Rx<bool> isTimerActive = false.obs;

  @override
  Future<void> onReady() async {
    super.onReady();
    timerTaskId = await SessionManagement.getTimerTaskId();
    isTimerActive.value = await SessionManagement.isTimerActive();
  }

  void startTimer(String id, int counterValue) async {
    isTimerActive.value = await SessionManagement.isTimerActive();

    if (isTimerActive.value) {
      CustomSnackBarView.showCustomErrorToast(message: "msg");
    } else {
      await SessionManagement.setTimer(timerTaskId: id, counter: counterValue);
      timerTaskId = id;
      isTimerActive.value = true;
      counter.value = await SessionManagement.getCounter();
      startTimer1();
    }
  }

  void startTimer1() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      counter++;
      SessionManagement.updateTimer(counter: counter.value);
    });
  }

  void stopTimer() async {
    _timer?.cancel();
    updateTimer();
    SessionManagement.removeTimer();
    timerTaskId = "";
    isTimerActive.value = false;
  }

  void resetTimer() {
    _timer?.cancel();
    counter.value = 0;
  }

  updateTimer() async {
    timerTaskId = await SessionManagement.getTimerTaskId();
    int duration = await SessionManagement.getCounter();
    Map<String, dynamic>? queryParameters = {
      "duration": duration.toString(),
      "duration_unit": "minute"
    };
    await BaseClient.safeApiCall(
        '${ConfigEnvironments.getEnvironments()['url']!}${Api.tasks}/${timerTaskId.toString()}',
        queryParameters: queryParameters,
        RequestType.post, onSuccess: (response) {
      if (response.body.isNotEmpty) {
      } else {
        CustomSnackBarView.showCustomSuccessToast(
            message: "Something went wrong. Try again in a few minutes");
      }
    }, onError: (error) {
      CustomSnackBarView.showCustomSuccessToast(message: error.message);
    });
  }

  @override
  void onClose() {
    _timer
        ?.cancel(); // Ensure timer is canceled when the controller is disposed
    super.onClose();
  }
}
