import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shamstore/core/helpers/spacing.dart';
import 'package:flutter_shamstore/core/localization/localization_helper.dart';
import 'package:flutter_shamstore/core/localization/language_bloc.dart';
import 'package:flutter_shamstore/features/auth/logic/auth_bloc.dart';
import 'package:flutter_shamstore/core/utils/text_utils.dart';

class ImageNameNotif extends StatelessWidget {
  const ImageNameNotif({super.key});

  String _getGreetingKey() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'good_morning';
    } else if (hour >= 12 && hour < 17) {
      return 'good_afternoon';
    } else {
      return 'good_evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, languageState) {
        return BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            String userName = context.tr('user_name'); // Default fallback
            String avatarUrl =
                'https://picsum.photos/150/150'; // Fallback image

            if (authState is AuthAuthenticated) {
              userName = authState.user.name.isNotEmpty
                  ? authState.user.name
                  : authState.user.email.split('@').first;
              // Generate avatar URL with user's name using a more reliable service
              final encodedName = Uri.encodeComponent(
                userName.replaceAll(' ', '+'),
              );
              // Use DiceBear API as a more reliable alternative
              avatarUrl =
                  'https://api.dicebear.com/7.x/initials/png?seed=$encodedName&backgroundColor=0D8ABC&textColor=ffffff';
            }

            // Check if Arabic mode is active
            bool isArabicMode =
                languageState is LanguageLoaded &&
                languageState.languageCode == 'ar';

            return Row(
              textDirection: isArabicMode
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              children: [
                // الصورة الدائرية
                Container(
                  width: 53.w,
                  height: 53.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300], // Fallback background color
                  ),
                  child: ClipOval(
                    child: Image.network(
                      avatarUrl,
                      width: 53.w,
                      height: 53.h,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback widget when image fails to load
                        return Container(
                          width: 53.w,
                          height: 53.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF0D8ABC),
                          ),
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 30.w,
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: 53.w,
                          height: 53.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[300],
                          ),
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF0D8ABC),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                horizontalspace(8.w), // مسافة بين الصورة والنصوص
                // النصوص
                Expanded(
                  child: Column(
                    crossAxisAlignment: isArabicMode
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.tr(_getGreetingKey()),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w200,
                        ),
                        textDirection: isArabicMode
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                      ),
                      //verticalspace(5.h),
                      Text(
                        userName.isNotEmpty
                            ? userName
                            : (languageState is LanguageLoaded &&
                                      languageState.languageCode == 'ar'
                                  ? 'مستخدم'
                                  : 'User'),
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        textDirection:
                            userName.isNotEmpty &&
                                languageState is LanguageLoaded &&
                                languageState.languageCode == 'ar' &&
                                TextUtils.containsArabic(userName)
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                      ),
                    ],
                  ),
                ),

                // زر الإشعارات
                SizedBox(
                  width: 25.w,
                  height: 25.h,
                  child: FloatingActionButton(
                    onPressed: () {
                      // الكود اللي بدك ينفذ لما المستخدم يضغط الكبسة
                    },
                    mini: true, // عشان يكون صغير
                    child: Icon(Icons.notifications, size: 15.sp),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
