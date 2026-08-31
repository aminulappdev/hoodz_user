import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/features/user/payment/presentation/widgets/details_section_card.dart';

class OrderDetailsCard extends StatelessWidget {
  final String orderNumber;
  final String itemsCount;
  final String paymentMethod;
  final String totalAmount;

  const OrderDetailsCard({
    super.key, 
    required this.orderNumber,
    required this.itemsCount,
    required this.paymentMethod,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return DetailsSectionCard(
      title: Strings.orderDetails.tr,
      child: Column(
        children: [
          DetailsInfoRow(label: Strings.orderNumber.tr, value: orderNumber),
          DetailsInfoRow(label: Strings.items.tr, value: itemsCount),
          DetailsInfoRow(
            label: Strings.payment.tr,
            value: paymentMethod,
            showDivider: false,
          ),
          Padding(
            padding: EdgeInsets.only(top: 12.h(context)),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    Strings.totalAmount.tr,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 15.sp(context),
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF676767),
                    ),
                  ),
                ),
                Text(
                  totalAmount,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 28.sp(context),
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF4A4A4A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DeliveryAddressCard extends StatelessWidget {
  final String buildingNumber;
  final String floorNumber;
  final String apartmentNumber;
  final String addressLine;
  final String note;

  const DeliveryAddressCard({
    super.key, 
    required this.buildingNumber,
    required this.floorNumber,
    required this.apartmentNumber,
    required this.addressLine,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return DetailsSectionCard(
      title: Strings.deliveryAddress.tr,
      child: Column(
        children: [
          DetailsInfoRow(label: Strings.buildingNo.tr, value: buildingNumber),
          DetailsInfoRow(label: Strings.floorNo.tr, value: floorNumber),
          DetailsInfoRow(label: Strings.apartment.tr, value: apartmentNumber),
          DetailsInfoRow(label: Strings.address.tr, value: addressLine),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(top: 2.h(context)),
              child: Text(
                Strings.note.tr,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14.sp(context),
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF9B9B9B),
                ),
              ),
            ),
          ),
          SizedBox(height: 6.h(context)),
          Text(
            note,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 12.sp(context),
              fontWeight: FontWeight.w400,
              color: const Color(0xFFAEAEAE),
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
