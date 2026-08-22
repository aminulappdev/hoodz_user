import 'package:flutter/material.dart';
import 'package:hoodz/core/widgets/custom_appbar.dart';
import 'package:hoodz/features/user/payment/presentation/widgets/support_option_tile.dart';

const Color kOrange = Color(0xFFE8622C);
const Color kBgGrey = Color(0xFFF6F6F8);

// ============================================================================
// SCREEN: CustomerServiceScreen
// ============================================================================
// StatelessWidget here — nothing on this screen changes over time (no
// selection, no timer, no toggling). It just displays a static list of
// options and reacts to taps by navigating away. Whenever a screen's
// entire job is "show data + navigate on tap", Stateless is the right
// choice — don't reach for State just because a screen "feels complex".
// ============================================================================
class CustomerServiceScreen extends StatelessWidget {
  const CustomerServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Data-driven list: each row is described as plain data (SupportOption),
    // then mapped to widgets below. This means adding a 4th option later
    // is a one-line change here — you never touch the widget-building code.
    final List<SupportOption> getSupportOptions = [
      SupportOption(
        emoji: '📦',
        iconBg: const Color(0xFFFFF1E6),
        title: 'Help with orders',
        onTap: () {
          // Navigator.pushNamed(context, AppRoutes.helpWithOrders);
        },
      ),
      SupportOption(
        emoji: '💬',
        iconBg: const Color(0xFFFFF1E6),
        title: 'Help with something else',
        onTap: () {
          // Navigator.pushNamed(context, AppRoutes.helpOther);
        },
      ),
    ];

    final List<SupportOption> followUpOptions = [
      SupportOption(
        emoji: '📩',
        iconBg: const Color(0xFFFFF1E6),
        title: 'Support inbox',
        onTap: () {
          // Navigator.pushNamed(context, AppRoutes.supportInbox);
        },
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(label: 'Customer Service'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Text(
              'Get Support',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            // for-in inside a widget list (with the spread `...`? not
            // even needed here since children: expects a List<Widget>
            // and Dart lets you build one with a `for` directly).
            for (final option in getSupportOptions)
              SupportOptionTile(option: option),
            const SizedBox(height: 16),
            Text(
              'Follow Up',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            for (final option in followUpOptions)
              SupportOptionTile(option: option),
          ],
        ),
      ),
    );
  }
}
