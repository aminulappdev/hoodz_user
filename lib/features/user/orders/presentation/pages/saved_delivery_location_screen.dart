import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/routes/app_routes.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/features/user/orders/data/models/save_address_model.dart'
    as saved_address;
import 'package:hoodz/features/user/orders/presentation/controllers/saved_location_controller.dart';

class SavedDeliveryLocationScreen extends GetView<SavedLocationController> {
  const SavedDeliveryLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                14.w(context),
                8.h(context),
                14.w(context),
                0,
              ),
              child: Row(
                children: [
                  _CloseButton(
                    onTap: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  _AddAddressButton(
                    onTap: () async {
                      await Navigator.pushNamed(
                        context,
                        AppRoutes.shippingInformation,
                      );
                      if (context.mounted) {
                        await controller.fetchSavedLocations();
                      }
                    },
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
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value &&
                    controller.savedAddresses.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.savedAddresses.isEmpty) {
                  return _EmptySavedAddress(
                    onRetry: controller.fetchSavedLocations,
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.fetchSavedLocations,
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: controller.savedAddresses.length,
                    separatorBuilder: (_, __) => const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFEDEDED),
                    ),
                    itemBuilder: (context, index) {
                      final address = controller.savedAddresses[index];
                      return _SavedAddressTile(
                        address: address,
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
                );
              }),
            ),
          ],
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

class _SavedAddressTile extends StatelessWidget {
  const _SavedAddressTile({
    required this.address,
    required this.isSelected,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final saved_address.Datum address;
  final bool isSelected;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final activeColor = Theme.of(context).primaryColor;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          8.w(context),
          10.h(context),
          14.w(context),
          10.h(context),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Radio<String?>(
              value: address.id,
              groupValue: isSelected ? address.id : null,
              activeColor: activeColor,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              onChanged: (_) => onTap(),
            ),
            SizedBox(width: 2.w(context)),
            const Icon(
              Icons.location_on_outlined,
              size: 20,
              color: Color(0xFF545454),
            ),
            SizedBox(width: 10.w(context)),
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
