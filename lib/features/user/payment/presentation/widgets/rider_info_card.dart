import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';

class RiderInfoCard extends StatelessWidget {
  final String imageUrl;
  final String riderName;
  final String rating;
  final String vehicleId;
  final String phoneNumber;
  final double? liveTrackingButtonWidth;
  final double? liveTrackingButtonHeight;
  final VoidCallback onMessageTap;
  final VoidCallback onLiveTrackingTap;

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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 14.w(context),
        vertical: 14.h(context),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r(context)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22.r(context),
                backgroundImage: NetworkImage(imageUrl),
              ),
              SizedBox(width: 12.w(context)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          riderName,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontSize: 19.sp(context),
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF373737),
                              ),
                        ),
                        IconButton(
                          onPressed: onMessageTap,
                          icon: const Icon(
                            Icons.message_rounded,
                            size: 24,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h(context)),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: const Color(0xFFFFBC2C),
                          size: 16.sp(context),
                        ),
                        SizedBox(width: 4.w(context)),
                        Text(
                          rating,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontSize: 14.sp(context),
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF636363),
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h(context)),
          Row(
            children: [
              Expanded(
                child: _RiderMeta(
                  icon: Icons.two_wheeler_outlined,
                  text: vehicleId,
                ),
              ),
              Container(
                width: 1,
                height: 20.h(context),
                color: const Color(0xFFEAEAEA),
              ),
              Expanded(
                child: _RiderMeta(
                  alignEnd: true,
                  icon: Icons.phone_outlined,
                  text: phoneNumber,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 12.h(context),
              horizontal: 12.w(context),
            ),
            child: SizedBox(
              width: liveTrackingButtonWidth ?? double.infinity,
              height: liveTrackingButtonHeight ?? 50.h(context),
              child: Material(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.redAccent),
                  borderRadius: BorderRadius.circular(15.r(context)),
                ),
                child: InkWell(
                  onTap: onLiveTrackingTap,
                  borderRadius: BorderRadius.circular(15.r(context)),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 3.r(context),
                          backgroundColor: Colors.redAccent,
                        ),
                        SizedBox(width: 6.w(context)),
                        Text(
                          'Live Tracking',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontSize: 15.sp(context),
                                fontWeight: FontWeight.w500,
                                color: Colors.redAccent,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RiderMeta extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool alignEnd;

  const _RiderMeta({
    required this.icon,
    required this.text,
    this.alignEnd = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: alignEnd
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Icon(icon, size: 15.sp(context), color: const Color(0xFF7F7F7F)),
        SizedBox(width: 6.w(context)),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 15.sp(context),
            fontWeight: FontWeight.w500,
            color: const Color(0xFF666666),
          ),
        ),
      ],
    );
  }
}
