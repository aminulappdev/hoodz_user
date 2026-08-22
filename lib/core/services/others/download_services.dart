// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:open_filex/open_filex.dart';

// class ResumeDownloadService {
//   static Future<void> downloadAndOpen({
//     required String url,
//     required String fileName,
//   }) async {
//     // Permission চাওয়া
//     var status = await Permission.storage.status;
//     if (!status.isGranted) {
//       status = await Permission.storage.request();
//       if (!status.isGranted) {
//         throw 'Storage permission denied';
//       }
//     }

//     // ফাইল সেভের জন্য ডিরেক্টরি
//     final directory = await getApplicationDocumentsDirectory();
//     final savePath = '${directory.path}/$fileName';

//     // ডাউনলোড করা
//     await Dio().download(url, savePath);

//     // ডাউনলোডের পরে ফাইল ওপেন করা
//     await OpenFilex.open(savePath);
//   }
// }
