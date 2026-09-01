import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
              child: Obx(() {
                if (controller.isLoading.value && controller.messages.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.separated(
                  padding: EdgeInsets.fromLTRB(
                  16.w(context),
                  20.h(context),
                  16.w(context),
                  20.h(context),
                ),
                  itemCount: controller.messages.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h(context)),
                  itemBuilder: (context, index) {
                    final message = controller.messages[index];
                    final products = (message['products'] as List?)
                            ?.whereType<Map<String, dynamic>>()
                            .toList() ??
                        const <Map<String, dynamic>>[];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MessageBubble(
                          message: message['text']?.toString() ?? '',
                          isMe: message['isMe'] == true,
                          files: (message['files'] as List?)
                                  ?.map((file) => file.toString())
                                  .toList() ??
                              const [],
                          timestamp: _formatTime(message['createdAt']),
                        ),
                        if (products.isNotEmpty) ...[
                          SizedBox(height: 10.h(context)),
                          ...products.map(
                            (product) => Padding(
                              padding: EdgeInsets.only(bottom: 10.h(context)),
                              child: RecommendationCard(
                                brand: _productValue(product, ['brand', 'brandName', 'brandKey']),
                                name: _productValue(product, ['name', 'productName', 'nameKey']),
                                price: _productValue(product, ['price', 'salePrice']),
                              ),
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                );
              }),
            ),
            CustomInputBar(onSend: controller.sendMessage),
          ],
        ),
      ),
    );
  }

  String _formatTime(dynamic value) {
    final date = DateTime.tryParse(value?.toString() ?? '');
    if (date == null) return '';
    final hour = date.hour == 0 ? 12 : (date.hour > 12 ? date.hour - 12 : date.hour);
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute ${date.hour >= 12 ? 'PM' : 'AM'}';
  }

  String _productValue(Map<String, dynamic> product, List<String> keys) {
    for (final key in keys) {
      final value = product[key];
      if (value != null && value.toString().isNotEmpty) return value.toString();
    }
    return '';
  }
}
