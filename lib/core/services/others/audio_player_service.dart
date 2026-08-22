// import 'dart:async';

// import 'package:deenduniya/app/data/utils/show_app_toast.dart';
// import 'package:just_audio/just_audio.dart';

// class AudioPlayerService {
//   final AudioPlayer _player = AudioPlayer();
//   String? _loadedSource;
 
//   Stream<Duration> get positionStream => _player.positionStream;
//   Stream<Duration?> get durationStream => _player.durationStream;
//   Stream<bool> get playingStream => _player.playerStateStream
//       .map(
//         (state) =>
//             state.playing && state.processingState != ProcessingState.completed,
//       )
//       .distinct();

//   Future<void> toggle(String? audioFile) async {
//     final source = audioFile?.trim();
//     final uri = source == null || source.isEmpty ? null : Uri.tryParse(source);

//     if (uri == null || !uri.hasScheme) {
//       showAppToast(message: 'Audio is not available.', isError: true);
//       return;
//     }

//     try {
//       if (_loadedSource != source) {
//         await _player.setUrl(source!);
//         _loadedSource = source;
//       }

//       if (_player.processingState == ProcessingState.completed) {
//         await _player.seek(Duration.zero);
//       }

//       if (_player.playing) {
//         await _player.pause();
//       } else {
//         unawaited(_player.play());
//       }
//     } catch (_) {
//       showAppToast(message: 'Could not play audio.', isError: true);
//     }
//   }

//   Future<void> seek(Duration position) => _player.seek(position);

//   Future<void> dispose() => _player.dispose();
// }
