import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hoodz/app/routes/app_routes.dart';
import 'package:hoodz/core/services/others/page_navigation_service.dart';

class SupportOptionTile extends StatelessWidget {
  final SupportOption option;

  const SupportOptionTile({super.key, required this.option});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          PageNavigationService.to(
            context,
            AppRoutes.aiAssistant,
            arguments: {
              'isShowBackButton': true,
              'title': 'Customer support',
              'subtitle': 'Online',
            },
          );
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFEEEEEE)),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: option.iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(option.emoji, style: const TextStyle(fontSize: 18)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  option.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// SupportOption — plain data model
// ============================================================================
// NOT a widget, just a value holder. Keeping `onTap` inside the model
// (instead of a separate parallel list of callbacks) means each option's
// data and its behaviour travel together — you can never accidentally
// mismatch option #2's title with option #3's callback.
// ============================================================================
class SupportOption {
  final String emoji;
  final Color iconBg;
  final String title;
  final VoidCallback onTap;

  const SupportOption({
    required this.emoji,
    required this.iconBg,
    required this.title,
    required this.onTap,
  });
}
