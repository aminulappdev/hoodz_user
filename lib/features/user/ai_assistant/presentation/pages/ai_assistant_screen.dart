import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
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
        arguments?['title'] as String? ?? title ?? 'Customer support';
    final resolvedSubtitle =
        arguments?['subtitle'] as String? ?? subtitle ?? 'Powered by AI';

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
                    message:
                        "Hi! I'm your AI Fashion Assistant✨ How can I help you "
                        'style your look today?',
                    isMe: false,
                    timestamp: '04:02 PM',
                  ),
                  SizedBox(height: 10.h(context)),
                  const MessageBubble(
                    message: 'Show me white shirts',
                    isMe: true,
                    timestamp: '04:02 PM',
                  ),
                  SizedBox(height: 18.h(context)),
                  const MessageBubble(
                    message:
                        'I found some perfect white shirts for you! Here are my '
                        'top picks:',
                    isMe: false,
                  ),
                  SizedBox(height: 12.h(context)),
                  ...controller.products.map(
                    (product) => Padding(
                      padding: EdgeInsets.only(bottom: 10.h(context)),
                      child: RecommendationCard(
                        brand: product['brand'] ?? '',
                        name: product['name'] ?? '',
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
