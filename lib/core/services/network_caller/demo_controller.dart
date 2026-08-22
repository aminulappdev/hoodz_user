/*

// Details Controller ...................................................
// .....................................................................

class SingleJobController extends GetxController {
  final RxBool _inProgress = false.obs;
  bool get inProgress => _inProgress.value;

  final RxString _errorMessage = ''.obs;
  String get errorMessage => _errorMessage.value;

  final Rx<SingleJobModel?> _singleJobModel = Rx<SingleJobModel?>(null);
  JobData? get singleJobData => _singleJobModel.value?.data;

  Future<bool> getSingleJob(String id) async {
    _inProgress.value = true;

    try {
      final NetworkResponse response = await Get.find<NetworkCaller>()
          .getRequest(
            Urls.singleJobById(id),
            accessToken: StorageUtil.getData(StorageUtil.userAccessToken),
          );

      if (response.isSuccess && response.responseData != null) {
        _errorMessage.value = '';

        _singleJobModel.value = SingleJobModel.fromJson(response.responseData);
        _inProgress.value = false;
        return true;
      } else {
        _errorMessage.value = response.errorMessage;
        _errorMessage.value.contains('expired') ? Get.to(SignInScreen()) : null;
        _inProgress.value = false;
        return false;
      }
    } catch (e) {
      _errorMessage.value = 'Failed to fetch district data: ${e.toString()}';
      print('Error fetching district data: $e');
      _inProgress.value = false;
      return false;
    }
  }
}


// Pagination Controller ...................................................
// .....................................................................

class AllFeedJobController extends GetxController {
  final NetworkCaller networkCaller = Get.find<NetworkCaller>();

  final RxBool _inProgress = false.obs;
  bool get inProgress => _inProgress.value;

  final RxString _errorMessage = ''.obs;
  String get errorMessage => _errorMessage.value;

  final RxList<FeedJobItemModel> _allJobList = <FeedJobItemModel>[].obs;
  List<FeedJobItemModel> get allJobData => _allJobList;

  final int _limit = 20;
  int page = 0;
  int? lastPage;

  // Category filter
  final RxString _selectedCategoryId = ''.obs;
  String get selectedCategoryId => _selectedCategoryId.value;
  set selectedCategoryId(String value) {
    _selectedCategoryId.value = value;
    resetPagination(); // Reset and fetch data when category changes
    update(); // Ensure UI updates
  }

  Future<bool> getJobs({String? categoryId}) async {
    if (_inProgress.value) {
      print('Fetch already in progress, skipping');
      return false;
    }

    if (lastPage != null && page >= lastPage!) {
      print('Reached last page: $lastPage');
      _inProgress.value = false;
      update();
      return false; // Stop if we've reached the last page
    }

    _inProgress.value = true;
    update();

    try {
      // Increment page after checking lastPage
      page++;
      print('Fetching assets for page: $page');

      Map<String, dynamic> queryParams = {'limit': _limit, 'page': page};
      final effectiveCategoryId = categoryId ?? _selectedCategoryId.value;
      if (effectiveCategoryId.isNotEmpty) {
        queryParams['category'] = effectiveCategoryId;
      }

      print('Fetching assets with params: $queryParams');

      final NetworkResponse response = await networkCaller.getRequest(
        Urls.feedJobUrl,
        queryParams: queryParams,
        accessToken: StorageUtil.getData(StorageUtil.userAccessToken),
      );

      print('Raw response: ${response.responseData}');

      if (response.isSuccess && response.responseData != null) {
        _errorMessage.value = '';
        FeedJobModel jobModel = FeedJobModel.fromJson(response.responseData);
        _allJobList.addAll(jobModel.data?.jobs ?? []);

        if (jobModel.data?.meta?.total != null &&
            jobModel.data?.meta?.limit != null) {
          lastPage = (jobModel.data!.meta!.total! / jobModel.data!.meta!.limit!)
              .ceil();
          print('Last page calculated: $lastPage');
        }

        _inProgress.value = false;
        update();
        return true;
      } else {
        _errorMessage.value = response.errorMessage;
        if (_errorMessage.value.contains('expired')) {
          Get.to(() => SignInScreen());
        }
        _inProgress.value = false;
        update();
        return false;
      }
    } catch (e) {
      _errorMessage.value = 'Failed to fetch asset data: ${e.toString()}';
      print('Error fetching asset data: $e');
      _inProgress.value = false;
      update();
      return false;
    }
  }

  void resetPagination() {
    page = 0; // Reset to 0 so first call uses page 1
    lastPage = null;
    _allJobList.clear();
    print('Pagination reset, fetching with categoryId: $_selectedCategoryId');
    getJobs(categoryId: _selectedCategoryId.value);
  }
}


// Normal Controller ...................................................
// .....................................................................

class AllConnectionController extends GetxController {
  final RxBool _inProgress = false.obs;
  bool get inProgress => _inProgress.value;

  final RxString _errorMessage = ''.obs;
  String get errorMessage => _errorMessage.value;

  final Rx<AllConnectionModel?> _allConnectionModel = Rx<AllConnectionModel?>(
    null,
  );
  List<AllConnectionItemModel>? get allConnectionData =>
      _allConnectionModel.value!.data?.connections;

  // @override
  // void onInit() {
  //   super.onInit();
  //   getMyProfile();
  // }

  Future<bool> getAllConnection(String? status) async {
    _inProgress.value = true;

    Map<String, dynamic> params = {"status": status};
    try {
      final NetworkResponse response = await Get.find<NetworkCaller>()
          .getRequest(
            Urls.allConnectionUrl,
            queryParams: params,
            accessToken: StorageUtil.getData(StorageUtil.userAccessToken),
          );

      if (response.isSuccess && response.responseData != null) {
        _errorMessage.value = '';

        _allConnectionModel.value = AllConnectionModel.fromJson(
          response.responseData,
        );

        _inProgress.value = false;
        return true;
      } else {
        _errorMessage.value = response.errorMessage;
        _errorMessage.value.contains('expired') ? Get.to(SignInScreen()) : null;
        _inProgress.value = false;
        return false;
      }
    } catch (e) {
      _errorMessage.value = 'Failed to fetch district data: ${e.toString()}';
      print('Error fetching district data: $e');
      _inProgress.value = false;
      return false;
    }
  }
}



*/
