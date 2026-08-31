import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/custom_appbar.dart';
import 'package:hoodz/features/user/profile/presentation/controller/content_controller.dart';

class ContentScreen extends StatefulWidget {
  const ContentScreen({super.key});

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  late final ContentController _controller;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller = Get.find<ContentController>();

      if (!_initialized) {
        _initialized = true;
        final arguments =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final title = arguments?['title']?.toString() ?? Strings.content.tr;
      final key = arguments?['key']?.toString() ?? 'userTermsAndConditions';
      _controller.loadContent(key: key, title: title);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Obx(
          () => CustomAppBar(label: _controller.pageTitle.value),
        ),
      ),
      body: Obx(() {
        if (_controller.isLoading.value &&
            _controller.htmlContent.value.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_controller.htmlContent.value.isEmpty) {
          return Center(child: Text(Strings.contentNotFound.tr));
        }

        return SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.w(context)),
            child: Html(data: _controller.htmlContent.value),
          ),
        );
      }),
    );
  }
}
