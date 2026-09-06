import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/core/services/referral/referral_service.dart';
import 'package:hoodz/core/utils/flutter_toast.dart';
import 'package:hoodz/features/user/profile/presentation/controller/profile_controller.dart';
import 'package:share_plus/share_plus.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/custom_appbar.dart';
import 'package:hoodz/core/widgets/custom_button.dart';

class PointsScreen extends StatelessWidget {
  const PointsScreen({super.key});

  String _formatCoins(dynamic coins) {
    if (coins is num) {
      return coins.toInt().toString();
    }

    final parsedCoins = int.tryParse(coins?.toString() ?? '');
    return (parsedCoins ?? 0).toString();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final profileController = Get.find<ProfileController>();
    final referralService = Get.find<ReferralService>();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      appBar: CustomAppBar(label: 'Points'),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                16.w(context),
                12,
                16.w(context),
                24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: width,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: const Color(0xFFFFD6B0)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1A000000),
                          blurRadius: 20,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 54,
                          width: 54,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF1E6),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.brightness_5_rounded,
                            color: Color(0xFFFF6A00),
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(
                                () => Text(
                                  '${_formatCoins(profileController.userData?.coins)} Points',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFFFF6A00),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '1 Coin = EGP 1.00\nRedeem from 50 coins at checkout.',
                                style: TextStyle(
                                  fontSize: 12,
                                  height: 1.35,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  _SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'App Referral Link',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey.shade900,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                height: 48,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF7F7F7),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: const Color(0xFFE7E7E7),
                                  ),
                                ),
                                alignment: Alignment.centerLeft,
                                child: Obx(() {
                                  final code =
                                      profileController.userData?.referralCode;
                                  final link =
                                      code == null || code.trim().isEmpty
                                      ? 'Referral link unavailable'
                                      : referralService.buildReferralLink(code);
                                  return Text(
                                    link,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade700,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  );
                                }),
                              ),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 86,
                              height: 48,
                              child: CustomButton(
                                text: 'Share',
                                height: 48,
                                onPressed: () async {
                                  final code =
                                      profileController.userData?.referralCode;
                                  if (code == null || code.trim().isEmpty) {
                                    showAppToast(
                                      message: 'Referral link is not available',
                                      isError: true,
                                    );
                                    return;
                                  }
                                  await SharePlus.instance.share(
                                    ShareParams(
                                      text:
                                          referralService.buildReferralLink(code),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'How It Works',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.grey.shade900,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const _HowItWorksItem(
                          icon: Icons.share_outlined,
                          title: 'Share your link',
                          subtitle: 'Send your unique app link to friends.',
                        ),
                        const SizedBox(height: 12),
                        const _HowItWorksItem(
                          icon: Icons.person_add_alt_1_outlined,
                          title: 'Friend signs up',
                          subtitle:
                              'Your friend creates an account using your link.',
                        ),
                        const SizedBox(height: 12),
                        const _HowItWorksItem(
                          icon: Icons.savings_outlined,
                          title: 'Earn points',
                          subtitle:
                              'Get 30 coins as inviter after your friend\'s first order. Invitees get 20 coins on a first order over EGP 500.',
                        ),
                        const SizedBox(height: 14),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF5EC),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFFFD9B8)),
                          ),
                          child: Text(
                            'Bonus tip:\nComplete your profile for 10 coins, write verified reviews to earn more, and redeem coins at checkout when your balance reaches 50 coins.',
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.45,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        const _RulesSection(
                          title: '1. Earning Scheme',
                          headers: [
                            'Trigger Action',
                            'Coins Earned',
                            'Maximum Cap',
                          ],
                          rows: [
                            _RuleRow(
                              values: [
                                'Standard Purchase',
                                '1 Coin per EGP 100 spent',
                                'No limit',
                              ],
                            ),
                            _RuleRow(
                              values: [
                                'Account Creation',
                                '20 Coins (Welcome Bonus)',
                                'Once per user',
                              ],
                            ),
                            _RuleRow(
                              values: [
                                'Complete Profile',
                                '10 Coins',
                                'Once per user',
                              ],
                            ),
                            _RuleRow(
                              values: [
                                'Verified Product Review',
                                '5 Coins',
                                '2 reviews / month',
                              ],
                            ),
                            _RuleRow(
                              values: [
                                'Photo / Outfit Review',
                                '15 Coins',
                                '2 reviews / month',
                              ],
                            ),
                            _RuleRow(
                              values: [
                                'Referral (Inviter)',
                                '30 Coins',
                                "After friend's 1st order",
                              ],
                            ),
                            _RuleRow(
                              values: [
                                'Referral (Invitee)',
                                '20 Coins',
                                'On 1st order over EGP 500',
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        const _RulesSection(
                          title: '2. Redemption & Financial Safeguards',
                          headers: [
                            'Rule',
                            'Requirement / Constraint',
                          ],
                          rows: [
                            _RuleRow(
                              values: [
                                'Coin Conversion',
                                '1 Coin = EGP 1.00',
                              ],
                            ),
                            _RuleRow(
                              values: [
                                'Min. Balance Needed',
                                '50 Coins (EGP 50 value)',
                              ],
                            ),
                            _RuleRow(
                              values: [
                                'Min. Basket Size',
                                'EGP 500 subtotal',
                              ],
                            ),
                            _RuleRow(
                              values: [
                                'Max. Checkout Cap',
                                '15% of basket subtotal',
                              ],
                            ),
                            _RuleRow(
                              values: [
                                'Product Exclusions',
                                'Discounted / Clearance items',
                              ],
                            ),
                            _RuleRow(
                              values: [
                                'Delivery Exclusions',
                                'Applies to cart only (not shipping fees)',
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RulesSection extends StatelessWidget {
  const _RulesSection({
    required this.title,
    required this.headers,
    required this.rows,
  });

  final String title;
  final List<String> headers;
  final List<_RuleRow> rows;

  @override
  Widget build(BuildContext context) {
    final columnFlexes = headers.length == 3
        ? const <int>[11, 11, 11]
        : const <int>[10, 13];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: Colors.grey.shade900,
          ),
        ),
        const SizedBox(height: 12),
        _RuleTableRow(
          values: headers,
          flexes: columnFlexes,
          isHeader: true,
        ),
        ...rows.map(
          (row) => _RuleTableRow(
            values: row.values,
            flexes: columnFlexes,
          ),
        ),
      ],
    );
  }
}

class _RuleRow {
  const _RuleRow({required this.values});

  final List<String> values;
}

class _RuleTableRow extends StatelessWidget {
  const _RuleTableRow({
    required this.values,
    required this.flexes,
    this.isHeader = false,
  });

  final List<String> values;
  final List<int> flexes;
  final bool isHeader;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: isHeader ? 10 : 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFE8E8E8)),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(values.length, (index) {
          return Expanded(
            flex: flexes[index],
            child: Padding(
              padding: EdgeInsets.only(
                right: index == values.length - 1 ? 0 : 12,
              ),
              child: Text(
                values[index],
                style: TextStyle(
                  fontSize: isHeader ? 12 : 12.5,
                  height: 1.35,
                  fontWeight: isHeader ? FontWeight.w600 : FontWeight.w500,
                  color: isHeader
                      ? Colors.grey.shade700
                      : const Color(0xFF242424),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _HowItWorksItem extends StatelessWidget {
  const _HowItWorksItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 34,
          width: 34,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF0E4),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 18, color: const Color(0xFFFF6A00)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF202020),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.4,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
