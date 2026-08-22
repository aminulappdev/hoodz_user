import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/core/widgets/custom_appbar.dart';
import 'package:hoodz/features/user/profile/presentation/controller/content_controller.dart';

class ContentScreen extends GetView<ContentController> {
  const ContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(label: 'Privacy Policy'),
      body: SafeArea(child: Center(child: Text('Content Screen'))),
    );
  }
}
