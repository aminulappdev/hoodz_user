import 'package:flutter/material.dart';
import 'package:hoodz/core/services/others/image_preview_service.dart';
import 'package:hoodz/core/utils/app_responsive.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    this.files = const <String>[],
    this.timestamp,
    this.showBubble = true,
  });

  final String message;
  final bool isMe;
  final List<String> files;
  final String? timestamp; 
  final bool showBubble;

  @override
  Widget build(BuildContext context) {
    final messageContent = Column(
      crossAxisAlignment: isMe
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showBubble)
          Container(
            constraints: BoxConstraints(
              maxWidth: isMe ? 200.w(context) : 286.w(context),
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (files.isNotEmpty) ...[
                  _AttachmentGrid(files: files, isMe: isMe),
                  if (message.isNotEmpty) SizedBox(height: 10.h(context)),
                ],
                if (message.isNotEmpty)
                  Text(
                    message,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isMe ? Colors.white : const Color(0xFF8C8C8C),
                      fontFamily: 'Poppins',
                      fontSize: isMe ? 13.sp(context) : 14.sp(context),
                      fontWeight: FontWeight.w400,
                      height: isMe ? null : 1.45,
                    ),
                  ),
              ],
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

class _AttachmentGrid extends StatelessWidget {
  const _AttachmentGrid({required this.files, required this.isMe});

  final List<String> files;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final visibleFiles = files.take(4).toList();
    final extraCount = files.length - visibleFiles.length;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(visibleFiles.length, (index) {
        final url = visibleFiles[index];
        final size = _imageSize(context, visibleFiles.length);

        return GestureDetector(
          onTap: () => _showPreview(context, index),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.r(context)),
            child: Stack(
              children: [
                Image.network(
                  url,
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: size,
                    height: size,
                    color: isMe
                        ? Colors.white.withValues(alpha: 0.08)
                        : const Color(0xFFE8E8E8),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: isMe
                          ? Colors.white.withValues(alpha: 0.7)
                          : const Color(0xFF8C8C8C),
                    ),
                  ),
                ),
                if (extraCount > 0 && index == 3)
                  Container(
                    width: size,
                    height: size,
                    color: Colors.black54,
                    alignment: Alignment.center,
                    child: Text(
                      '+$extraCount',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }

  double _imageSize(BuildContext context, int count) {
    if (count <= 1) {
      return 170.w(context);
    }
    if (count == 2) {
      return 118.w(context);
    }
    return 80.w(context);
  }

  void _showPreview(BuildContext context, int initialIndex) {
    ImagePreviewService.show(
      context: context,
      images: files,
      initialIndex: initialIndex,
    );
  }
}
