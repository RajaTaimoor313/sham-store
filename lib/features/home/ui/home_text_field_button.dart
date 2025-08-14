import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shamstore/core/widgets/app_text_form_field.dart';
import 'package:flutter_shamstore/core/localization/localization_helper.dart';
import 'package:flutter_shamstore/features/categories/logic/product_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shamstore/features/home/ui/product_search_page.dart';

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
              hintText: context.tr('search_customers'),
              prefixIcon: const Icon(Icons.search),
              borderRadius: 50.r,
              onFieldSubmitted: (value) {
                final query = value.trim();
                if (query.isEmpty) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (_) => ProductCubit()..searchProducts(query),
                      child: ProductSearchPage(query: query),
                    ),
                  ),
                );
              },
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
