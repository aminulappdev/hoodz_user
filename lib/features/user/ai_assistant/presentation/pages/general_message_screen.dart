import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/features/user/chat/presentation/controllers/general_message_controller.dart';
import 'package:hoodz/features/user/ai_assistant/presentation/widgets/custom_chat_header.dart';
import 'package:hoodz/features/user/ai_assistant/presentation/widgets/custom_input_bar.dart';
import 'package:hoodz/features/user/ai_assistant/presentation/widgets/message_bubble.dart';

class GeneralMessageScreen extends GetView<GeneralMessageController> {
  final bool? isShowBackButton;
  final String? title;
  final String? subtitle;

  const GeneralMessageScreen({
    super.key,
    this.isShowBackButton,
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments is Map<String, dynamic>
        ? Get.arguments as Map<String, dynamic>
        : null;
    final resolvedIsShowBackButton =
        arguments?['isShowBackButton'] as bool? ?? isShowBackButton ?? true;
    final resolvedTitle = controller.chatTitle.value.isNotEmpty
        ? controller.chatTitle.value
        : arguments?['title'] as String? ?? title ?? 'Customer support';
    final resolvedSubtitle = controller.chatSubtitle.value.isNotEmpty
        ? controller.chatSubtitle.value
        : arguments?['subtitle'] as String? ?? subtitle ?? 'Powered by AI';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomChatHeader(
        subtitle: resolvedSubtitle,
        label: resolvedTitle,
        isShowBackButton: resolvedIsShowBackButton,
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value && controller.messages.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.messages.isEmpty) {
            return const Center(
              child: Text(
                'No messages found',
                style: TextStyle(color: Colors.black54),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.fromLTRB(
                    16.w(context),
                    20.h(context),
                    16.w(context),
                    20.h(context),
                  ),
                  itemCount: controller.messages.length,
                  separatorBuilder: (_, __) => SizedBox(height: 10.h(context)),
                  itemBuilder: (context, index) {
                    final message = controller.messages[index];
                    return MessageBubble(
                      message: message['text']?.toString() ?? '',
                      isMe: controller.isOwnMessage(message),
                      timestamp: _formatTimestamp(
                        DateTime.tryParse(
                          message['createdAt']?.toString() ?? '',
                        ),
                      ),
                    );
                  },
                ),
              ),
              const CustomInputBar(),
            ],
          );
        }),
      ),
    );
  }

  String _formatTimestamp(DateTime? value) {
    if (value == null) {
      return '';
    }

    final local = value.toLocal();
    final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
    final minute = local.minute.toString().padLeft(2, '0');
    final period = local.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}
