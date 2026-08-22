import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hoodz/core/utils/app_responsive.dart';

class CopyCodeButton extends StatelessWidget {
  final String code;

  const CopyCodeButton({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () async {
        await Clipboard.setData(ClipboardData(text: code));
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Code "$code" copied'),
              duration: const Duration(seconds: 1),
            ),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.all(8.w(context)),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.copy_all_outlined,
              size: 14.w(context),
              color: Colors.white,
            ),
            SizedBox(width: 6.w(context)),
            Text(
              'Code',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp(context),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
