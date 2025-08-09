import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shamstore/core/themina/colors.dart';

class AppTextFormField extends StatelessWidget {
  final String hintText;
  final String? labelText;
  final TextEditingController? controller;
  final bool? isObscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double borderRadius; // ✅ أضف هذا
  //final maxLines; maxLines; ?? 1;
  final int? maxLines;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  const AppTextFormField({
    super.key,
    required this.hintText,
    this.labelText,
    this.controller,
    this.isObscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.borderRadius = 12.0, 
    this.maxLines,
    this.validator, // ✅ قيمة افتراضية
    this.keyboardType,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          Text(
            labelText!,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: ColorsManager.mainBlack,
            ),
          ),
        ],
        TextFormField(
          maxLines: maxLines ?? 1,
          controller: controller,
          obscureText: isObscureText ?? false,
          validator: validator,
          keyboardType: keyboardType,
          onChanged: onChanged,
          style: TextStyle(
            fontSize: 16.sp,
            color: ColorsManager.mainBlack,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 14.sp,
              color: Color.fromARGB(255, 237, 236, 236),
            ),
            prefixIcon: prefixIcon != null
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: IconTheme(
                      data: IconThemeData(
                        color: const Color.fromARGB(255, 237, 236, 236),
                        size: 22.sp,
                      ),
                      child: prefixIcon!,
                    ),
                  )
                : null,
            prefixIconConstraints: BoxConstraints(minWidth: 40.w, minHeight: 40.h),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: ColorsManager.mainWhite,
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),

            // ✅ استخدم borderRadius المرسل
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius.r),
              borderSide: BorderSide(color: ColorsManager.mainGrey.withOpacity(0.3), width: 1.2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius.r),
              borderSide: BorderSide(color: ColorsManager.mainGrey.withOpacity(0.3), width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius.r),
              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.8),
            ),
          ),
        ),
      ],
    );
  }
}
