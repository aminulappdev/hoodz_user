// import '../../../../core/network/api_client.dart';
// import '../models/user_model.dart';

// class AuthRemoteDataSource {
//   AuthRemoteDataSource({ApiClient? apiClient})
//       : _apiClient = apiClient ?? const ApiClient();

//   final ApiClient _apiClient;

//   Future<UserModel> login({
//     required String phone,
//     required String password,
//   }) async {
//     final response = await _apiClient.post(
//       '/auth/login',
//       body: <String, dynamic>{
//         'phone': phone,
//         'password': password,
//       },
//     );

//     return UserModel.fromJson(<String, dynamic>{
//       'id': 1,
//       'name': 'Demo User',
//       'role': phone.startsWith('9') ? 'rider' : 'user',
//       'token': 'temporary-token',
//       ...response,
//     });
//   }
// }
