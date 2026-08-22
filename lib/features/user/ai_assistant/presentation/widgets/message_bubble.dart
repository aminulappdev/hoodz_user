
import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    this.timestamp,
    this.showBubble = true,
  });

  final String message;
  final bool isMe;
  final String? timestamp;
  final bool showBubble;

  @override
  Widget build(BuildContext context) {
    final messageContent = Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showBubble)
          Container(
            constraints: BoxConstraints(
              maxWidth: isMe ? 160.w(context) : 286.w(context),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: isMe ? 14.w(context) : 12.w(context),
              vertical: 10.h(context),
            ),
            decoration: BoxDecoration(
              color: isMe ? const Color(0xFF3B3B3B) : const Color(0xFFF3F3F3),
              borderRadius: BorderRadius.circular(
                isMe ? 12.r(context) : 14.r(context),
              ),
            ),
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isMe ? Colors.white : const Color(0xFF8C8C8C),
                fontFamily: 'Poppins',
                fontSize: isMe ? 13.sp(context) : 14.sp(context),
                fontWeight: FontWeight.w400,
                height: isMe ? null : 1.45,
              ),
            ),
          ),
        if (timestamp != null) ...[
          SizedBox(height: 4.h(context)),
          Text(
            timestamp!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF7B7B7B),
              fontFamily: 'Poppins',
              fontSize: 11.sp(context),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ],
    );

    if (!isMe) {
      return messageContent;
    }

    return Align(alignment: Alignment.centerRight, child: messageContent);
  }
}