import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

void showSafeGetSnackbar(String title, String message) {
  if (SchedulerBinding.instance.schedulerPhase == SchedulerPhase.idle) {
    Get.snackbar(title, message);
    return;
  }

  WidgetsBinding.instance.addPostFrameCallback((_) {
    Get.snackbar(title, message);
  });
}
