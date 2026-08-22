class ApiClient {
  const ApiClient();

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    return <String, dynamic>{
      'path': path,
      'body': body ?? <String, dynamic>{},
    };
  }
}
