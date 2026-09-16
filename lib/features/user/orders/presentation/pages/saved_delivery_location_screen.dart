import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/routes/app_routes.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/shimmer/order_shimmer.dart';
import 'package:hoodz/features/user/homescreen/presentation/widgets/location_selection_sheet.dart';
import 'package:hoodz/features/user/orders/presentation/controllers/saved_location_controller.dart';

class SavedDeliveryLocationScreen extends StatelessWidget {
  const SavedDeliveryLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: SavedDeliveryLocationSheet()),
    );
  }
}

class SavedDeliveryLocationSheet extends GetView<SavedLocationController> {
  const SavedDeliveryLocationSheet({
    super.key,
    this.onTapCurrentLocation,
    this.onTapDifferentLocation,
    this.isLoadingCurrentLocation = false,
  });

  final Future<void> Function()? onTapCurrentLocation;
  final Future<void> Function()? onTapDifferentLocation;
  final bool isLoadingCurrentLocation;

  Future<void> _openShippingInformation(BuildContext context) async {
    await Navigator.pushNamed(context, AppRoutes.shippingInformation);
    if (context.mounted) {
      await controller.fetchSavedLocations();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.92,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 7.h(context)),
                width: 42.w(context),
                height: 4.h(context),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                14.w(context),
                10.h(context),
                14.w(context),
                0,
              ),
              child: Row(
                children: [
                  _CloseButton(onTap: () => Navigator.pop(context)),
                  const Spacer(),
                  _AddAddressButton(
                    onTap: () => _openShippingInformation(context),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                14.w(context),
                18.h(context),
                14.w(context),
                0,
              ),
              child: Text(
                'Choose delivery location',
                style: textTheme.titleMedium?.copyWith(
                  fontSize: 18.sp(context),
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF252525),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                14.w(context),
                26.h(context),
                14.w(context),
                10.h(context),
              ),
              child: Text(
                'Saved addresses',
                style: textTheme.bodyMedium?.copyWith(
                  fontSize: 14.sp(context),
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF252525),
                ),
              ),
            ),
            Obx(() {
              if (controller.isLoading.value &&
                  controller.savedAddresses.isEmpty) {
                return ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 320.h(context)),
                  child: const SavedLocationListShimmer(),
                );
              }

              if (controller.savedAddresses.isEmpty) {
                return _EmptySavedAddress(
                  onRetry: controller.fetchSavedLocations,
                );
              }

              final visibleAddresses =
                  controller.savedAddresses.take(5).toList(growable: false);

              return ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 320.h(context)),
                child: RefreshIndicator(
                  onRefresh: controller.fetchSavedLocations,
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: visibleAddresses.length > 4
                        ? const AlwaysScrollableScrollPhysics()
                        : const NeverScrollableScrollPhysics(),
                    itemCount: visibleAddresses.length,
                    separatorBuilder: (_, __) => const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFEDEDED),
                    ),
                    itemBuilder: (context, index) {
                      final address = visibleAddresses[index];
                      return _SavedAddressTile(
                        isSelected:
                            controller.selectedAddressId.value == address.id,
                        title: controller.addressTitle(address),
                        subtitle: controller.addressSubtitle(address),
                        onTap: () async {
                          final success =
                              await controller.applySavedAddress(address);
                          if (success && context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                      );
                    },
                  ),
                ),
              );
            }),
            _LocationActions(
              isLoadingCurrentLocation: isLoadingCurrentLocation,
              onTapDifferentLocation: onTapDifferentLocation ??
                  () async => _openShippingInformation(context),
              onTapCurrentLocation: onTapCurrentLocation ??
                  () async => _openShippingInformation(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 32.w(context),
        height: 32.w(context),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE7E7E7)),
        ),
        child: const Icon(
          Icons.close_rounded,
          size: 20,
          color: Color(0xFF4D4D4D),
        ),
      ),
    );
  }
}

class _AddAddressButton extends StatelessWidget {
  const _AddAddressButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 34.h(context),
        padding: EdgeInsets.symmetric(horizontal: 12.w(context)),
        decoration: BoxDecoration(
          color: const Color(0xFF252525),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.add_rounded,
              size: 18,
              color: Colors.white,
            ),
            SizedBox(width: 4.w(context)),
            Text(
              'Add',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 12.sp(context),
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SavedAddressTile extends StatelessWidget {
  const _SavedAddressTile({
    required this.isSelected,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final bool isSelected;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      child: Container(
        color: isSelected ? const Color(0xFFFFF8F4) : Colors.white,
        padding: EdgeInsets.fromLTRB(
          14.w(context),
          10.h(context),
          14.w(context),
          10.h(context),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.location_on_outlined,
              size: 20,
              color: Color(0xFF545454),
            ),
            SizedBox(width: 12.w(context)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyMedium?.copyWith(
                      fontSize: 13.sp(context),
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF333333),
                    ),
                  ),
                  SizedBox(height: 2.h(context)),
                  Text(
                    subtitle.isEmpty ? Strings.notAvailable.tr : subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall?.copyWith(
                      fontSize: 11.sp(context),
                      fontWeight: FontWeight.w500,
                      height: 1.25,
                      color: const Color(0xFF8A8A8A),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LocationActions extends StatelessWidget {
  const _LocationActions({
    required this.onTapCurrentLocation,
    required this.onTapDifferentLocation,
    required this.isLoadingCurrentLocation,
  });

  final Future<void> Function() onTapCurrentLocation;
  final Future<void> Function() onTapDifferentLocation;
  final bool isLoadingCurrentLocation;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        14.w(context),
        10.h(context),
        14.w(context),
        12.h(context),
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEDEDED))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LocationOptionTile(
            icon: Icons.location_on_outlined,
            iconColor: const Color(0xFF9C9C9C),
            title: Strings.deliverToDifferentLocation.tr,
            borderColor: const Color(0xFFEDEDED),
            backgroundColor: const Color(0xFFF9F9F9),
            onTap: () {
              unawaited(onTapDifferentLocation());
            },
          ),
          SizedBox(height: 12.h(context)),
          LocationOptionTile(
            icon: Icons.my_location_rounded,
            iconColor: const Color(0xFFFF6A00),
            title: Strings.deliverToCurrentLocation.tr,
            borderColor: const Color(0xFFFFD6BD),
            backgroundColor: const Color(0xFFFFFAF6),
            isLoading: isLoadingCurrentLocation,
            onTap: () {
              unawaited(onTapCurrentLocation());
            },
          ),
        ],
      ),
    );
  }
}

class _EmptySavedAddress extends StatelessWidget {
  const _EmptySavedAddress({required this.onRetry});

  final Future<bool> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w(context)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.location_off_outlined,
              size: 38,
              color: Color(0xFF9A9A9A),
            ),
            SizedBox(height: 12.h(context)),
            Text(
              Strings.noAddressAdded.tr,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 14.sp(context),
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF444444),
                  ),
            ),
            SizedBox(height: 12.h(context)),
            TextButton(
              onPressed: () => onRetry(),
              child: Text(Strings.retry.tr),
            ),
          ],
        ),
      ),
    );
  }
}
