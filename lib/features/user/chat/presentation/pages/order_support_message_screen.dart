import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/shimmer/chat_shimmer.dart';
import 'package:hoodz/features/user/ai_assistant/presentation/widgets/custom_chat_header.dart';
import 'package:hoodz/features/user/ai_assistant/presentation/widgets/custom_input_bar.dart';
import 'package:hoodz/features/user/ai_assistant/presentation/widgets/message_bubble.dart';
import 'package:hoodz/features/user/chat/presentation/controllers/order_support_message_controller.dart';

class OrderSupportMessageScreen extends StatefulWidget {
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
  State<OrderSupportMessageScreen> createState() =>
      _OrderSupportMessageScreenState();
}

class _OrderSupportMessageScreenState extends State<OrderSupportMessageScreen>
    with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();
  late final OrderSupportMessageController controller;
  int _lastMessageCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    controller = Get.find<OrderSupportMessageController>();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    _scrollToBottom(delay: const Duration(milliseconds: 260));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments is Map<String, dynamic>
        ? Get.arguments as Map<String, dynamic>
        : null;
    final resolvedIsShowBackButton =
        arguments?['isShowBackButton'] as bool? ??
        widget.isShowBackButton ??
        true;
    final resolvedOrderId = controller.orderId.value.trim().isNotEmpty
        ? controller.orderId.value.trim()
        : arguments?['orderId']?.toString().trim() ?? '';
    final resolvedTitle = controller.chatTitle.value.isNotEmpty
        ? controller.chatTitle.value
        : arguments?['title'] as String? ??
        widget.title ??
        Strings.orderSupportChat.tr;
    final resolvedSubtitle = resolvedOrderId.isNotEmpty
        ? 'Order ID: $resolvedOrderId'
        : controller.chatSubtitle.value.isNotEmpty
            ? controller.chatSubtitle.value
            : arguments?['subtitle'] as String? ??
                  widget.subtitle ??
                  Strings.online.tr;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomChatHeader(
        subtitle: resolvedSubtitle,
        label: resolvedTitle,
        isShowBackButton: resolvedIsShowBackButton,
      ),
      body: SafeArea(
        child: Obx(() {
          _queueScrollWhenMessagesChange(controller.messages.length);
          if (controller.isInitialLoading.value ||
              (controller.isLoading.value && controller.messages.isEmpty)) {
            return Column(
              children: [
                const Expanded(child: ChatMessagesShimmer()),
                CustomInputBar(
                  hintText: Strings.typeAMessage.tr,
                  onSend: controller.sendMessage,
                ),
              ],
            );
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
                  controller: _scrollController,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.fromLTRB(
                    16.w(context),
                    20.h(context),
                    16.w(context),
                    24.h(context),
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

  void _queueScrollWhenMessagesChange(int messageCount) {
    if (_lastMessageCount == messageCount) return;
    _lastMessageCount = messageCount;
    _scrollToBottom();
  }

  void _scrollToBottom({Duration delay = const Duration(milliseconds: 80)}) {
    Future<void>.delayed(delay, () {
      if (!mounted || !_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    });
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
