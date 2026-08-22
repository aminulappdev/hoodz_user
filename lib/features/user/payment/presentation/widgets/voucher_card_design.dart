import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/features/user/payment/presentation/models/voucher_model.dart';
import 'package:hoodz/features/user/payment/presentation/pages/voucher_screen.dart';
import 'package:hoodz/features/user/payment/presentation/widgets/copy_code_button.dart';
import 'package:hoodz/features/user/payment/presentation/widgets/dash_border_container.dart';

class VoucherCardDesign extends StatelessWidget {
  final Voucher voucher;
  final bool showDetailsSection;
  final bool isCompact;

  const VoucherCardDesign({
    super.key,
    required this.voucher,
    this.showDetailsSection = true,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive = voucher.status == VoucherStatus.active;

    return Container(
      padding: EdgeInsets.all(isCompact ? 12 : 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF0F0F0)),
        // Used/expired vouchers are visually muted so "Active" clearly
        // reads as the actionable state.
        color: isActive ? Colors.white : const Color(0xFFFAFAFA),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Container(
                padding: EdgeInsets.all(isCompact ? 7.w(context) : 8.w(context)),
                decoration: BoxDecoration(
                  color: kPeach,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.confirmation_number_outlined,
                  size: isCompact ? 18.h(context) : 20.h(context),
                  color: isActive ? kOrange : Colors.grey.shade500,
                ),
              ),
              SizedBox(width: isCompact ? 10.w(context) : 12.w(context)),
              Flexible(
                fit: FlexFit.tight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      voucher.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: (isCompact ? 15 : 16).sp(context),
                        fontWeight: FontWeight.w700,
                        color: isActive ? Colors.black : Colors.grey.shade500,
                      ),
                    ),
                    SizedBox(height: isCompact ? 1.h(context) : 2.h(context)),
                    Text(
                      voucher.subtitle,
                      maxLines: isCompact ? 3 : (showDetailsSection ? 2 : 4),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: (isCompact ? 11 : 12).sp(context),
                        color: Colors.grey.shade600,
                        height: isCompact ? 1.35 : null,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: isCompact ? 8.w(context) : 12.w(context)),
              if (isActive)
                CopyCodeButton(code: voucher.code)
              else
                _StatusBadge(status: voucher.status),
            ],
          ),
          if (showDetailsSection) ...[
            SizedBox(height: isCompact ? 10.h(context) : 12.h(context)),
            DashedBorderContainer(
              color: Colors.grey.shade300,
              borderRadius: 10,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isCompact ? 10.w(context) : 14,
                  vertical: isCompact ? 8.h(context) : 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      voucher.code,
                      style: TextStyle(
                        fontSize: (isCompact ? 13 : 14).sp(context),
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(width: 12.w(context)),
                    Container(width: 1, height: 16, color: Colors.grey.shade300),
                    SizedBox(width: 12.w(context)),
                    Text(
                      voucher.expiryText,
                      style: TextStyle(
                        fontSize: (isCompact ? 12 : 13).sp(context),
                        fontWeight: FontWeight.w500,
                        color: isActive ? kOrange : Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final VoucherStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final label = status == VoucherStatus.used ? 'Used' : 'Expired';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade600,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
