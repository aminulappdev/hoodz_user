import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/features/user/ai_assistant/presentation/widgets/custom_chat_header.dart';
import 'package:hoodz/features/user/ai_assistant/presentation/widgets/custom_input_bar.dart';
import 'package:hoodz/features/user/ai_assistant/presentation/widgets/message_bubble.dart';
import 'package:hoodz/features/user/chat/presentation/controllers/order_support_message_controller.dart';

class OrderSupportMessageScreen extends GetView<OrderSupportMessageController> {
  final bool? isShowBackButton;
  final String? title;
  final String? subtitle;

  const OrderSupportMessageScreen({
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
        : arguments?['title'] as String? ?? title ?? Strings.orderSupportChat.tr;
    final resolvedSubtitle = controller.chatSubtitle.value.isNotEmpty
        ? controller.chatSubtitle.value
        : arguments?['subtitle'] as String? ?? subtitle ?? Strings.online.tr;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomChatHeader(
        subtitle: resolvedSubtitle,
        label: resolvedTitle,
        isShowBackButton: resolvedIsShowBackButton,
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isInitialLoading.value ||
              (controller.isLoading.value && controller.messages.isEmpty)) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.messages.isEmpty) {
            return Column(
              children: [
                 Expanded(
                  child: Center(
                    child: Text(
                      Strings.noMessagesFound.tr,
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                ),
                CustomInputBar(
                  hintText: Strings.typeAMessage.tr,
                  onSend: controller.sendMessage,
                ),
              ],
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
                      files: _extractFiles(message['files']),
                      timestamp: _formatTimestamp(
                        DateTime.tryParse(
                          message['createdAt']?.toString() ?? '',
                        ),
                      ),
                    );
                  },
                ),
              ),
              CustomInputBar(
                hintText: Strings.typeAMessage.tr,
                onSend: controller.sendMessage,
              ),
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

  List<String> _extractFiles(dynamic rawFiles) {
    if (rawFiles is! List) {
      return const <String>[];
    }

    return rawFiles
        .where((file) => file != null)
        .map((file) => file.toString().trim())
        .where((file) => file.isNotEmpty)
        .toList();
  }
}
