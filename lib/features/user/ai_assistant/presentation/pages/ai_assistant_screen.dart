import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/features/user/ai_assistant/presentation/controller/ai_assistant_controller.dart';
import 'package:hoodz/features/user/ai_assistant/presentation/widgets/custom_chat_header.dart';
import 'package:hoodz/features/user/ai_assistant/presentation/widgets/custom_input_bar.dart';
import 'package:hoodz/features/user/ai_assistant/presentation/widgets/message_bubble.dart';
import 'package:hoodz/features/user/ai_assistant/presentation/widgets/reccomandation_card.dart';

class AiAssistantScreen extends GetView<AiAssistantController> {
  final bool? isShowBackButton;
  final String? title;
  final String? subtitle;

  const AiAssistantScreen({
    super.key,
    this.isShowBackButton,
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final resolvedIsShowBackButton =
        arguments?['isShowBackButton'] as bool? ?? isShowBackButton ?? true;
    final resolvedTitle =
        arguments?['title'] as String? ?? title ?? Strings.aiAssistant.tr;
    final resolvedSubtitle =
        arguments?['subtitle'] as String? ?? subtitle ?? Strings.poweredByAI.tr;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomChatHeader(
        subtitle: resolvedSubtitle,
        label: resolvedTitle,
        isShowBackButton: resolvedIsShowBackButton,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  16.w(context),
                  20.h(context),
                  16.w(context),
                  20.h(context),
                ),
                children: [
                  MessageBubble(
                    message: Strings.aiFashionAssistantGreeting.tr,
                    isMe: false,
                    timestamp: '04:02 PM',
                  ),
                  SizedBox(height: 10.h(context)),
                  MessageBubble(
                    message: Strings.showMeWhiteShirts.tr,
                    isMe: true,
                    timestamp: '04:02 PM',
                  ),
                  SizedBox(height: 18.h(context)),
                  MessageBubble(
                    message: Strings.aiRecommendationIntro.tr,
                    isMe: false,
                  ),
                  SizedBox(height: 12.h(context)),
                  ...controller.products.map(
                    (product) => Padding(
                      padding: EdgeInsets.only(bottom: 10.h(context)),
                      child: RecommendationCard(
                        brand: (product['brandKey'] ?? '').tr,
                        name: (product['nameKey'] ?? '').tr,
                        price: product['price'] ?? '',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const CustomInputBar(),
          ],
        ),
      ),
    );
  }
}
