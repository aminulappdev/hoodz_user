// import '../../../../core/services/storage_service.dart';
// import '../datasources/auth_remote_data_source.dart';
// import '../models/user_model.dart';

// class AuthRepository {
//   AuthRepository({
//     AuthRemoteDataSource? remoteDataSource,
//     StorageService? storageService,
//   })  : _remoteDataSource = remoteDataSource ?? AuthRemoteDataSource(),
//         _storageService = storageService ?? const StorageService();

//   final AuthRemoteDataSource _remoteDataSource;
//   final StorageService _storageService;

//   Future<UserModel> login({
//     required String phone,
//     required String password,
//   }) async {
//     final user = await _remoteDataSource.login(
//       phone: phone,
//       password: password,
//     );
//     await _storageService.saveToken(user.token);
//     return user;
//   }
// }
