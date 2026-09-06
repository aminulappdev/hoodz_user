import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:shimmer/shimmer.dart';

class ChatMessagesShimmer extends StatelessWidget {
  const ChatMessagesShimmer({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(
        16.w(context),
        20.h(context),
        16.w(context),
        24.h(context),
      ),
      itemCount: itemCount,
      separatorBuilder: (_, _) => SizedBox(height: 14.h(context)),
      itemBuilder: (context, index) {
        final isMe = index.isOdd;
        return Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: _ChatBubbleShimmer(
            width: (MediaQuery.of(context).size.width *
                    (isMe ? 0.58 : 0.68))
                .clamp(140.w(context), 280.w(context))
                .toDouble(),
            height: isMe ? 52.h(context) : 68.h(context),
          ),
        );
      },
    );
  }
}

class ChatShimmerBox extends StatelessWidget {
  const ChatShimmerBox({
    super.key,
    required this.height,
    required this.width,
    this.radius = 8,
    this.circle = false,
  });

  final double height;
  final double width;
  final double radius;
  final bool circle;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE7E7E7),
      highlightColor: const Color(0xFFF8F8F8),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: circle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: circle ? null : BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

class _ChatBubbleShimmer extends StatelessWidget {
  const _ChatBubbleShimmer({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE7E7E7),
      highlightColor: const Color(0xFFF8F8F8),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r(context)),
        ),
      ),
    );
  }
}
