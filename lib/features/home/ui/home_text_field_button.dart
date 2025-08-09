import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shamstore/core/widgets/app_text_form_field.dart';


class TextFieldSButton extends StatelessWidget {
  const TextFieldSButton({super.key});

  @override
  Widget build(BuildContext context) {
    const double height = 56;
  return SizedBox(
    height: height,
    child: Row(
      children: [
        Flexible(
          flex: 4, // حقل النص يأخذ 4/5 من المساحة
          child: AppTextFormField(
            hintText: "Search Customers",
            prefixIcon: const Icon(Icons.search),
            borderRadius: 50.r,
          ),
        ),
        // horizontalspace(8.w), // تقليل المسافة
        // Flexible(
        //   flex: 1, // الزر يأخذ 1/5 من المساحة
        //   child: AppTextButton(
        //     icon: Icon(Icons.menu),
        //     onPressed: () {},
        //     buttonHeight: height,
        //   ),
        // ),
      ],
    ),
  );
}
}