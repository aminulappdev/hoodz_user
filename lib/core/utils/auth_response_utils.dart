import 'package:hoodz/core/services/network_caller/network_response.dart';

bool isLoginRequiredResponse(NetworkResponse response) {
  final responseData = response.responseData;
  final statusCode = responseData is Map<String, dynamic>
      ? responseData['statusCode']?.toString()
      : null;
  final message = responseData is Map<String, dynamic>
      ? responseData['message']?.toString()
      : null;

  return response.statusCode == 401 ||
      statusCode == '401' ||
      response.errorMessage.trim().toLowerCase() == 'unauthorized access' ||
      response.message.trim().toLowerCase() == 'unauthorized access' ||
      message?.trim().toLowerCase() == 'unauthorized access';
}
