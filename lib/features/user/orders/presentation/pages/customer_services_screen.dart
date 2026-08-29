import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/utils/validator_services.dart';
import 'package:hoodz/core/widgets/custom_appbar.dart';
import 'package:hoodz/features/user/orders/presentation/controllers/customer_service_controller.dart';

class CustomerServiceScreen extends GetView<CustomerServiceController> {
  const CustomerServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(label: 'Customer Service'),
      body: SafeArea(
        child: Form(
          key: controller.formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              16.w(context),
              20.h(context),
              16.w(context),
              20.h(context),
            ),
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selected issue',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 18.sp(context),
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF202020),
                        ),
                  ),
                  SizedBox(height: 14.h(context)),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18.r(context)),
                      border: Border.all(color: const Color(0xFFEDEDED)),
                    ),
                    child: Column(
                      children: List.generate(controller.issueOptions.length, (
                        index,
                      ) {
                        final issue = controller.issueOptions[index];
                        final isSelected =
                            controller.selectedIssueIndex.value == index;

                        return InkWell(
                          onTap: () => controller.selectIssue(index),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w(context),
                              vertical: 16.h(context),
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFFFF6EF)
                                  : Colors.transparent,
                              border: index == controller.issueOptions.length - 1
                                  ? null
                                  : const Border(
                                      bottom: BorderSide(
                                        color: Color(0xFFF0F0F0),
                                      ),
                                    ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40.w(context),
                                  height: 40.w(context),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFF1E6),
                                    borderRadius: BorderRadius.circular(
                                      12.r(context),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.receipt_long_outlined,
                                    color: const Color(0xFFE8622C),
                                    size: 20.sp(context),
                                  ),
                                ),
                                SizedBox(width: 12.w(context)),
                                Expanded(
                                  child: Text(
                                    issue.label,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontSize: 15.sp(context),
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFF222222),
                                        ),
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: isSelected
                                      ? const Color(0xFFE8622C)
                                      : const Color(0xFFB7B7B7),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  SizedBox(height: 22.h(context)),
                  Text(
                    'Upload images',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 18.sp(context),
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF202020),
                        ),
                  ),
                  SizedBox(height: 12.h(context)),
                  InkWell(
                    onTap: controller.pickImages,
                    borderRadius: BorderRadius.circular(18.r(context)),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w(context),
                        vertical: 18.h(context),
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6F6F8),
                        borderRadius: BorderRadius.circular(18.r(context)),
                        border: Border.all(color: const Color(0xFFE8E8E8)),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            controller.isPickingImages.value
                                ? Icons.hourglass_empty_rounded
                                : Icons.cloud_upload_outlined,
                            color: const Color(0xFFE8622C),
                            size: 28.sp(context),
                          ),
                          SizedBox(height: 10.h(context)),
                          Text(
                            controller.isPickingImages.value
                                ? 'Picking images...'
                                : 'Tap to add multiple photos',
                            style:
                                Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontSize: 14.sp(context),
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF303030),
                                    ),
                          ),
                          SizedBox(height: 6.h(context)),
                          Text(
                            'You can choose multiple images from gallery',
                            textAlign: TextAlign.center,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontSize: 12.sp(context),
                                      color: const Color(0xFF777777),
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (controller.attachments.isNotEmpty) ...[
                    SizedBox(height: 14.h(context)),
                    SizedBox(
                      height: 84.h(context),
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.attachments.length,
                        separatorBuilder: (_, __) =>
                            SizedBox(width: 10.w(context)),
                        itemBuilder: (context, index) {
                          final file = controller.attachments[index];
                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  14.r(context),
                                ),
                                child: Image.file(
                                  file,
                                  width: 84.w(context),
                                  height: 84.h(context),
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 84.w(context),
                                    height: 84.h(context),
                                    color: const Color(0xFFF2F2F2),
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.image_not_supported_outlined,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: -6,
                                right: -6,
                                child: GestureDetector(
                                  onTap: () =>
                                      controller.removeAttachment(index),
                                  child: Container(
                                    width: 22,
                                    height: 22,
                                    decoration: const BoxDecoration(
                                      color: Colors.black87,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      size: 14,
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
                  ],
                  SizedBox(height: 22.h(context)),
                  Text(
                    'Note',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 18.sp(context),
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF202020),
                        ),
                  ),
                  SizedBox(height: 12.h(context)),
                  TextFormField(
                    controller: controller.noteCtrl,
                    validator: ValidatorService.validateSimpleField,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Write your note here...',
                      filled: true,
                      fillColor: const Color(0xFFF6F6F8),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w(context),
                        vertical: 16.h(context),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r(context)),
                        borderSide:
                            const BorderSide(color: Color(0xFFE8E8E8)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r(context)),
                        borderSide:
                            const BorderSide(color: Color(0xFFE8E8E8)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r(context)),
                        borderSide:
                            const BorderSide(color: Color(0xFFE8622C)),
                      ),
                    ),
                  ),
                  SizedBox(height: 26.h(context)),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.isSubmitting.value
                          ? null
                          : () async {
                              await controller.submitGrievance();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE8622C),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16.h(context)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r(context)),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        controller.isSubmitting.value
                            ? 'Submitting...'
                            : 'Submit',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontSize: 15.sp(context),
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
