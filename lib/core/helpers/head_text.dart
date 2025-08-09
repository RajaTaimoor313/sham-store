import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shamstore/core/localization/localization_helper.dart';

class HeadText extends StatelessWidget {
  const HeadText({
    super.key,
    this.textColor,
    this.showActionButton = true,
    required this.title,
    this.buttonTitle,
    this.onPressed,
    this.leftPadding = 16,
    this.rightPadding = 16,
  });

  final Color? textColor;
  final bool showActionButton;
  final String title;
  final String? buttonTitle;
  final void Function()? onPressed;
  final double leftPadding;
  final double rightPadding;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
            color: textColor ?? Colors.black87,
            decoration: TextDecoration.none,
          ),
        ),
        if (showActionButton)
          TextButton(
            onPressed: onPressed,
            child: Text(
              buttonTitle ?? context.tr('view_all'),
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
      ],
    );
  }
}
