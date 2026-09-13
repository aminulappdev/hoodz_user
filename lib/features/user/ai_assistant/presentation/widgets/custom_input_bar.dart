import 'dart:io';

import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/services/others/image_picker_service.dart';
import 'package:hoodz/core/services/upload_service.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/utils/login_required_dialog.dart';
import 'package:hoodz/core/utils/share_preference.dart';
import 'package:hoodz/core/widgets/image_source_picker_sheet.dart';
import 'package:hoodz/core/widgets/shimmer/chat_shimmer.dart';
import 'package:hoodz/gen/assets.gen.dart';
import 'package:image_picker/image_picker.dart';

class CustomInputBar extends StatefulWidget {
  const CustomInputBar({
    super.key,
    this.onSend,
    this.hintText,
    this.isSendDisabled = false,
  });

  final void Function(String text, List<String> files)? onSend;
  final String? hintText;
  final bool isSendDisabled;

  @override
  State<CustomInputBar> createState() => _CustomInputBarState();
}

class _CustomInputBarState extends State<CustomInputBar> {
  final TextEditingController _textController = TextEditingController();
  final List<String> _attachmentUrls = <String>[];
  bool _isUploadingAttachments = false;

  Future<void> _handlePickFile() async {
    if (_isUploadingAttachments) {
      return;
    }

    final accessToken = MySharedPref.getAccessToken();
    if (accessToken == null || accessToken.trim().isEmpty) {
      showLoginRequiredDialog();
      return;
    }

    final ImageSource? source = await showImageSourcePickerSheet(context);
    if (source == null) {
      return;
    }

    setState(() {
      _isUploadingAttachments = true;
    });

    try {
      final List<File> pickedFiles = await ImagePickerService.pickImages(
        source,
      );
      if (pickedFiles.isEmpty) {
        return;
      }

      final uploadService = Get.find<UploadService>();
      final uploadedUrls = <String>[];

      for (final file in pickedFiles) {
        final uploadedUrl = await uploadService.uploadSingleFile(
          accessToken: accessToken,
          file: file,
        );
        if (uploadedUrl != null && uploadedUrl.isNotEmpty) {
          uploadedUrls.add(uploadedUrl);
        }
      }

      if (!mounted || uploadedUrls.isEmpty) {
        return;
      }

      setState(() {
        _attachmentUrls.addAll(uploadedUrls);
      });
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingAttachments = false;
        });
      }
    }
  }

  void _removeAttachment(int index) {
    if (index < 0 || index >= _attachmentUrls.length) {
      return;
    }

    setState(() {
      _attachmentUrls.removeAt(index);
    });
  }

  void _handleSend() {
    if (_isUploadingAttachments || widget.isSendDisabled) {
      return;
    }

    final text = _textController.text.trim();
    if (text.isEmpty && _attachmentUrls.isEmpty) {
      return;
    }

    widget.onSend?.call(text, List<String>.from(_attachmentUrls));
    _textController.clear();
    setState(() {
      _attachmentUrls.clear();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isSendDisabled = _isUploadingAttachments || widget.isSendDisabled;
    final Color sendColor = isSendDisabled
        ? const Color(0xFFC9C9C9)
        : const Color(0xFFFF6A00);

    return Container(
      padding: EdgeInsets.fromLTRB(
        14.w(context),
        12.h(context),
        14.w(context),
        14.h(context),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_attachmentUrls.isNotEmpty || _isUploadingAttachments) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _isUploadingAttachments
                      ? Strings.uploadingAttachments.tr
                      : Strings.attachments.tr,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF7B7B7B),
                    fontFamily: 'Poppins',
                    fontSize: 12.sp(context),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 8.h(context)),
              SizedBox(
                height: 72.h(context),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount:
                      _attachmentUrls.length +
                      (_isUploadingAttachments ? 1 : 0),
                  separatorBuilder: (_, __) => SizedBox(width: 10.w(context)),
                  itemBuilder: (context, index) {
                    if (_isUploadingAttachments &&
                        index == _attachmentUrls.length) {
                      return Container(
                        width: 72.w(context),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4F4F4),
                          borderRadius: BorderRadius.circular(12.r(context)),
                        ),
                        child: Center(
                          child: ChatShimmerBox(
                            height: 22.h(context),
                            width: 22.w(context),
                            radius: 11.r(context),
                            circle: true,
                          ),
                        ),
                      );
                    }

                    final url = _attachmentUrls[index];
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.r(context)),
                          child: Image.network(
                            url,
                            width: 72.w(context),
                            height: 72.h(context),
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 72.w(context),
                              height: 72.h(context),
                              color: const Color(0xFFF4F4F4),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.image_not_supported_outlined,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => _removeAttachment(index),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(4),
                              child: const Icon(
                                Icons.close,
                                size: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 10.h(context)),
            ],
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 42.h(context),
                    padding: EdgeInsets.symmetric(horizontal: 12.w(context)),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF1E8),
                      borderRadius: BorderRadius.circular(12.r(context)),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: _handlePickFile,
                          child: CrashSafeImage(
                            Assets.icons.file.path,
                            width: 18.w(context),
                            height: 18.h(context),
                          ),
                        ),
                        SizedBox(width: 10.w(context)),
                        Expanded(
                          child: TextField(
                            controller: _textController,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => _handleSend(),
                            cursorColor: const Color(0xFFFF6A00),
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: const Color(0xFF4D4D4D),
                                  fontFamily: 'Poppins',
                                  fontSize: 13.sp(context),
                                  fontWeight: FontWeight.w400,
                                ),
                            decoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              hintText:
                                  widget.hintText ??
                                  Strings.askMeAnythingAboutFashion.tr,
                              hintStyle: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: const Color(0xFF9F8A81),
                                    fontFamily: 'Poppins',
                                    fontSize: 13.sp(context),
                                    fontWeight: FontWeight.w400,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10.w(context)),
                SizedBox(
                  height: 42.h(context),
                  width: 42.w(context),
                  child: Material(
                    color: sendColor,
                    borderRadius: BorderRadius.circular(10.r(context)),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10.r(context)),
                      onTap: isSendDisabled ? null : _handleSend,
                      child: Center(
                        child: CrashSafeImage(
                          Assets.icons.send.path,
                          width: 18.w(context),
                          height: 18.h(context),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
