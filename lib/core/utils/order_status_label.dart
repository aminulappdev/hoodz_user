import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:get/get.dart';

/// Maps API `ORDER_STATUS` values (always English) to the current locale.
class OrderStatusLabel {
  static String normalize(String? status) {
    return (status ?? '').trim().toLowerCase().replaceAll(' ', '_');
  }

  static String from(String? status) {
    switch (normalize(status)) {
      case 'pending':
        return Strings.pending.tr;
      case 'cancelled':
      case 'canceled':
      case 'cancel':
        return Strings.cancelled.tr;
      case 'confirmed':
        return Strings.confirmed.tr;
      case 'processing':
        return Strings.processing.tr;
      case 'rider_assigned':
        return Strings.riderAssigned.tr;
      case 'picked_up':
        return Strings.pickedUp.tr;
      case 'on_the_way':
        return Strings.onTheWay.tr;
      case 'delivered':
      case 'delivery':
      case 'completed':
      case 'complete':
        return Strings.delivered.tr;
      default:
        return Strings.processing.tr;
    }
  }
}
