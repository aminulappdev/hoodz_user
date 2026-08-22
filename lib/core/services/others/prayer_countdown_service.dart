// import 'dart:async';

// import 'package:intl/intl.dart';

// class PrayerScheduleItem {
//   final String name;
//   final String? time;

//   const PrayerScheduleItem({required this.name, required this.time});
// }

// class PrayerCountdown {
//   final String prayerName;
//   final Duration remaining;
 
//   const PrayerCountdown({
//     required this.prayerName,
//     required this.remaining,
//   });

//   String get formattedRemaining {
//     final hours = remaining.inHours.toString().padLeft(2, '0');
//     final minutes = (remaining.inMinutes % 60).toString().padLeft(2, '0');
//     final seconds = (remaining.inSeconds % 60).toString().padLeft(2, '0');
//     return '$hours:$minutes:$seconds';
//   }
// }

// class PrayerCountdownService {
//   Timer? _timer;
//   late DateTime _scheduleDate;
//   List<PrayerScheduleItem> _prayers = const [];
//   void Function(PrayerCountdown countdown)? _onTick;
//   Future<void> Function()? _onScheduleEnded;

//   void start({
//     required DateTime scheduleDate,
//     required List<PrayerScheduleItem> prayers,
//     required void Function(PrayerCountdown countdown) onTick,
//     required Future<void> Function() onScheduleEnded,
//   }) {
//     _timer?.cancel();
//     _scheduleDate = DateTime(
//       scheduleDate.year,
//       scheduleDate.month,
//       scheduleDate.day,
//     );
//     _prayers = prayers;
//     _onTick = onTick;
//     _onScheduleEnded = onScheduleEnded;
//     _scheduleNextPrayer();
//   }

//   void restart() {
//     if (_prayers.isNotEmpty) {
//       _scheduleNextPrayer();
//     }
//   }

//   void _scheduleNextPrayer() {
//     _timer?.cancel();

//     final now = DateTime.now();
//     final prayerTimes = _prayers
//         .map(
//           (prayer) => (
//             prayer: prayer,
//             dateTime: _parsePrayerDateTime(prayer.time),
//           ),
//         )
//         .where((entry) => entry.dateTime != null)
//         .toList()
//       ..sort((a, b) => a.dateTime!.compareTo(b.dateTime!));

//     ({PrayerScheduleItem prayer, DateTime dateTime})? nextPrayer;
//     for (final entry in prayerTimes) {
//       final dateTime = entry.dateTime;
//       if (dateTime != null && dateTime.isAfter(now)) {
//         nextPrayer = (prayer: entry.prayer, dateTime: dateTime);
//         break;
//       }
//     }

//     if (nextPrayer == null) {
//       _onScheduleEnded?.call();
//       return;
//     }

//     void emitCountdown() {
//       final remaining = nextPrayer!.dateTime.difference(DateTime.now());

//       if (remaining <= Duration.zero) {
//         _scheduleNextPrayer();
//         return;
//       }

//       _onTick?.call(
//         PrayerCountdown(
//           prayerName: nextPrayer!.prayer.name,
//           remaining: remaining,
//         ),
//       );
//     }

//     emitCountdown();
//     _timer = Timer.periodic(const Duration(seconds: 1), (_) => emitCountdown());
//   }

//   DateTime? _parsePrayerDateTime(String? value) {
//     if (value == null || value.trim().isEmpty) {
//       return null;
//     }

//     final time = value.trim().toUpperCase();
//     for (final pattern in [
//       'h:mm a',
//       'hh:mm a',
//       'H:mm:ss',
//       'HH:mm:ss',
//       'H:mm',
//       'HH:mm',
//     ]) {
//       try {
//         final parsedTime = DateFormat(pattern).parseStrict(time);
//         return DateTime(
//           _scheduleDate.year,
//           _scheduleDate.month,
//           _scheduleDate.day,
//           parsedTime.hour,
//           parsedTime.minute,
//           parsedTime.second,
//         );
//       } catch (_) {
//         // Try the next supported API time format.
//       }
//     }

//     return null;
//   }

//   String formatTimeForDisplay(String? value) {
//     if (value == null || value.trim().isEmpty) {
//       return '--:--';
//     }

//     final time = value.trim().toUpperCase();
//     for (final pattern in [
//       'h:mm a',
//       'hh:mm a',
//       'H:mm:ss',
//       'HH:mm:ss',
//       'H:mm',
//       'HH:mm',
//     ]) {
//       try {
//         return DateFormat(
//           'hh:mm a',
//         ).format(DateFormat(pattern).parseStrict(time));
//       } catch (_) {
//         // Try the next supported API time format.
//       }
//     }

//     return value;
//   }

//   void dispose() {
//     _timer?.cancel();
//   }
// }
