import 'package:get/get.dart';
import 'package:hoodz/core/services/network_caller/network_caller.dart';
import 'package:hoodz/core/utils/auth_response_utils.dart';
import 'package:hoodz/core/utils/flutter_toast.dart';
import 'package:hoodz/core/utils/login_required_dialog.dart';
import 'package:hoodz/core/utils/share_preference.dart';
import 'package:hoodz/features/user/profile/data/models/notification_model.dart';
import 'package:hoodz/urls.dart';

class NotificationController extends GetxController {
  final NetworkCaller _networkCaller = Get.find<NetworkCaller>();

  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxSet<String> markingDoneIds = <String>{}.obs;
  final Rx<MyNotificationModel?> _notificationModel =
      Rx<MyNotificationModel?>(null);

  int _currentPage = 1;
  int _totalPage = 1;

  MyNotificationModel? get notificationModel => _notificationModel.value;
  List<Datum> get notifications => _notificationModel.value?.data ?? const [];
  bool get hasMoreNotifications => _currentPage < _totalPage;

  Future<void> getNotifications({bool loadMore = false}) async {
    final accessToken = MySharedPref.getAccessToken();
    final hasAccessToken = accessToken?.trim().isNotEmpty == true;

    if (!hasAccessToken) {
      showLoginRequiredDialog();
      return;
    }

    if (loadMore) {
      if (isLoading.value ||
          isLoadingMore.value ||
          !hasMoreNotifications) {
        return;
      }
    } else {
      if (isLoading.value) {
        return;
      }

      _resetNotifications();
    }

    final page = loadMore ? _currentPage + 1 : 1;

    if (loadMore) {
      isLoadingMore.value = true;
    } else {
      isLoading.value = true;
    }

    try {
      final response = await _networkCaller.getRequest(
        Urls.notificationUrl,
        accessToken: accessToken,
        queryParams: {'page': page},
      );

      if (isLoginRequiredResponse(response)) {
        showLoginRequiredDialog();
        return;
      }

      if (response.isSuccess) {
        final model = MyNotificationModel.fromJson(response.responseData);
        _currentPage = model.meta?.page ?? page;
        _totalPage = model.meta?.totalPage ?? _currentPage;

        if (loadMore && _notificationModel.value != null) {
          _notificationModel.value = MyNotificationModel(
            success: model.success,
            statusCode: model.statusCode,
            message: model.message,
            meta: model.meta,
            data: [..._notificationModel.value!.data, ...model.data],
          );
        } else {
          _notificationModel.value = model;
        }
        return;
      }

      showAppToast(message: response.errorMessage, isError: true);
    } finally {
      if (loadMore) {
        isLoadingMore.value = false;
      } else {
        isLoading.value = false;
      }
    }
  }

  Future<void> refreshNotifications() async {
    await getNotifications();
  }

  Future<void> markAllAsDone() async {
    if (markingDoneIds.contains('__all__')) {
      return;
    }

    final accessToken = MySharedPref.getAccessToken();
    final hasAccessToken = accessToken?.trim().isNotEmpty == true;

    if (!hasAccessToken) {
      showLoginRequiredDialog();
      return;
    }

    markingDoneIds.add('__all__');

    try {
      final response = await _networkCaller.patchRequest(
        Urls.notificationUrl,
        accessToken: accessToken,
      );

      if (isLoginRequiredResponse(response)) {
        showLoginRequiredDialog();
        return;
      }

      if (response.isSuccess) {
        _markAllNotificationsReadLocally();
        return;
      }

      showAppToast(message: response.errorMessage, isError: true);
    } finally {
      markingDoneIds.remove('__all__');
    }
  }

  void _resetNotifications() {
    _currentPage = 1;
    _totalPage = 1;
    _notificationModel.value = null;
  }

  void _markAllNotificationsReadLocally() {
    final currentModel = _notificationModel.value;
    if (currentModel == null) {
      return;
    }

    _notificationModel.value = MyNotificationModel(
      success: currentModel.success,
      statusCode: currentModel.statusCode,
      message: currentModel.message,
      meta: currentModel.meta,
      data: currentModel.data
          .map((item) => item.copyWith(read: true))
          .toList(growable: false),
    );
  }
}
