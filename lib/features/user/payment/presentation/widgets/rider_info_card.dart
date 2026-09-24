import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/utils/app_responsive.dart';

class RiderInfoCard extends StatelessWidget {
  const RiderInfoCard({
    super.key,
    required this.imageUrl,
    required this.riderName,
    required this.rating,
    required this.vehicleId,
    required this.phoneNumber,
    this.liveTrackingButtonWidth,
    this.liveTrackingButtonHeight,
    required this.onMessageTap,
    required this.onLiveTrackingTap,
  });

  final String imageUrl;
  final String riderName;
  final String rating;
  final String vehicleId;
  final String phoneNumber;
  final double? liveTrackingButtonWidth;
  final double? liveTrackingButtonHeight;
  final VoidCallback onMessageTap;
  final VoidCallback onLiveTrackingTap;

  @override
  Widget build(BuildContext context) {
    final displayName =
        riderName.trim().isEmpty ? Strings.rider.tr : riderName.trim();
    final displayRating = rating.trim().isEmpty ? '0' : rating.trim();
    final displayVehicle =
        vehicleId.trim().isEmpty ? Strings.notAvailable.tr : vehicleId.trim();
    final displayPhone =
        phoneNumber.trim().isEmpty ? Strings.notAvailable.tr : phoneNumber.trim();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w(context)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r(context)),
        border: Border.all(color: const Color(0xFFF0F1F3)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _RiderAvatar(imageUrl: imageUrl),
              SizedBox(width: 12.w(context)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 18.sp(context),
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF262626),
                          ),
                    ),
                    SizedBox(height: 8.h(context)),
                    _RatingPill(rating: displayRating),
                  ],
                ),
              ),
              SizedBox(width: 10.w(context)),
              _MessageButton(onTap: onMessageTap),
            ],
          ),
          SizedBox(height: 16.h(context)),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12.w(context),
              vertical: 12.h(context),
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(12.r(context)),
              border: Border.all(color: const Color(0xFFF0F0F0)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _RiderMeta(
                    icon: Icons.two_wheeler_outlined,
                    text: displayVehicle,
                  ),
                ),
                Container(
                  width: 1,
                  height: 22.h(context),
                  color: const Color(0xFFE3E3E3),
                ),
                Expanded(
                  child: _RiderMeta(
                    icon: Icons.call_outlined,
                    text: displayPhone,
                    alignEnd: true,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h(context)),
          SizedBox(
            width: liveTrackingButtonWidth ?? double.infinity,
            height: liveTrackingButtonHeight ?? 42.h(context),
            child: OutlinedButton(
              onPressed: onLiveTrackingTap,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFFF4B4B),
                side: const BorderSide(color: Color(0xFFFF4B4B)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r(context)),
                ),
                padding: EdgeInsets.zero,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 6.w(context),
                    height: 6.w(context),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF4B4B),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 8.w(context)),
                  Text(
                    Strings.liveTracking.tr,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14.sp(context),
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFFF4B4B),
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RiderAvatar extends StatelessWidget {
  const _RiderAvatar({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48.w(context),
      height: 48.w(context),
      padding: const EdgeInsets.all(2),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFFFE6E6),
      ),
      child: CircleAvatar(
        backgroundColor: const Color(0xFFEDEDED),
        backgroundImage:
            imageUrl.trim().isEmpty ? null : NetworkImage(imageUrl.trim()),
        child: imageUrl.trim().isEmpty
            ? const Icon(
                Icons.person_rounded,
                color: Color(0xFF8A8A8A),
              )
            : null,
      ),
    );
  }
}

class _RatingPill extends StatelessWidget {
  const _RatingPill({required this.rating});

  final String rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.w(context),
        vertical: 4.h(context),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E6),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star_rounded,
            color: const Color(0xFFFFB800),
            size: 14.sp(context),
          ),
          SizedBox(width: 4.w(context)),
          Text(
            rating,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 12.sp(context),
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF3D3D3D),
                ),
          ),
        ],
      ),
    );
  }
}

class _MessageButton extends StatelessWidget {
  const _MessageButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFFFF0F0),
      borderRadius: BorderRadius.circular(10.r(context)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r(context)),
        child: SizedBox(
          width: 38.w(context),
          height: 38.w(context),
          child: const Icon(
            Icons.message_rounded,
            size: 22,
            color: Color(0xFFFF4B4B),
          ),
        ),
      ),
    );
  }
}

class _RiderMeta extends StatelessWidget {
  const _RiderMeta({
    required this.icon,
    required this.text,
    this.alignEnd = false,
  });

  final IconData icon;
  final String text;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          alignEnd ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Icon(icon, size: 15.sp(context), color: const Color(0xFF777777)),
        SizedBox(width: 7.w(context)),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: alignEnd ? TextAlign.right : TextAlign.left,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 13.sp(context),
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF646464),
                ),
          ),
        ),
      ],
    );
  }
}
