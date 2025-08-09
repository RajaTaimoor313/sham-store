import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shamstore/core/helpers/spacing.dart';
import 'package:flutter_shamstore/core/themina/colors.dart';
import 'package:flutter_shamstore/core/themina/font_weight_help.dart';
import 'package:flutter_shamstore/core/widgets/text_button.dart';
import 'package:flutter_shamstore/features/settings/ui/widgets/profile_edit.dart';
import 'package:flutter_shamstore/core/localization/localization_helper.dart';
import 'package:flutter_shamstore/core/localization/language_bloc.dart';
import 'package:flutter_shamstore/features/auth/logic/auth_bloc.dart';
import 'package:flutter_shamstore/core/routing/routes.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            context.tr('logout'),
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
          ),
          content: Text(
            context.tr('logout_confirmation'),
            style: TextStyle(fontSize: 16.sp),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                context.tr('cancel'),
                style: TextStyle(color: Colors.grey, fontSize: 14.sp),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AuthBloc>().add(AuthLogoutRequested());
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil(Routes.loginscreen, (route) => false);
              },
              child: Text(
                context.tr('logout'),
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Trigger API call to fetch user data when screen opens
    context.read<AuthBloc>().add(AuthGetUserRequested());

    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, languageState) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ColorsManager.mainWhite,
            title: Text(
              context.tr('profile'),
              style: TextStyle(color: ColorsManager.mainBlue),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                onPressed: () async {
                  // الانتقال لصفحة التعديل وانتظار النتيجة
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyProfileEdit()),
                  );

                  // إذا تم حفظ التعديلات، قم بإعادة تحميل البيانات
                  if (result == true) {
                    context.read<AuthBloc>().add(AuthGetUserRequested());
                  }
                },
                icon: Icon(Icons.edit),
              ),
            ],
          ),
          body: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthLoading) {
                return Center(child: CircularProgressIndicator());
              }

              if (state is AuthError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: ${state.message}'),
                      ElevatedButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(AuthGetUserRequested());
                        },
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (state is AuthAuthenticated) {
                return SafeArea(
                  child: SingleChildScrollView(
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(
                              'https://example.com/profile-image.png',
                            ),
                            backgroundColor: Colors.grey[200],
                          ),
                          verticalspace(24.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: ColorsManager.mainWhite,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: ColorsManager.mainWhite,
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.person_2_outlined,
                                      color: ColorsManager.mainBlue,
                                    ),
                                    horizontalspace(8.h),
                                    Text(
                                      context.tr('name'),
                                      style: TextStyle(
                                        color: ColorsManager.mainBlue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                verticalspace(8.h),
                                Text(
                                  state.user.name,
                                  style: TextStyle(
                                    color: ColorsManager.mainBlack,
                                    fontSize: 14,
                                  ),
                                ),
                                verticalspace(16.h),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.email,
                                      color: ColorsManager.mainBlue,
                                    ),
                                    horizontalspace(8.h),
                                    Text(
                                      context.tr('email'),
                                      style: TextStyle(
                                        color: ColorsManager.mainBlue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                verticalspace(8.h),
                                Text(
                                  state.user.email,
                                  style: TextStyle(
                                    color: ColorsManager.mainBlack,
                                    fontSize: 14,
                                  ),
                                ),
                                verticalspace(16.h),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.mobile_friendly,
                                      color: ColorsManager.mainBlue,
                                    ),
                                    horizontalspace(8.h),
                                    Text(
                                      context.tr('contact'),
                                      style: TextStyle(
                                        color: ColorsManager.mainBlue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                verticalspace(8.h),
                                Text(
                                  state.user.phone ?? 'N/A',
                                  style: TextStyle(
                                    color: ColorsManager.mainBlack,
                                    fontSize: 14,
                                  ),
                                ),
                                verticalspace(16.h),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: ColorsManager.mainBlue,
                                    ),
                                    horizontalspace(8.h),
                                    Text(
                                      context.tr('delivery_address'),
                                      style: TextStyle(
                                        color: ColorsManager.mainBlue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                verticalspace(8.h),
                                Text(
                                  state.user.address ?? 'N/A',
                                  style: TextStyle(
                                    color: ColorsManager.mainBlack,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          verticalspace(26.h),
                          Center(
                            child: Column(
                              children: [
                                AppTextButton(
                                  onPressed: () => _showLogoutDialog(context),
                                  buttonText: context.tr('logout'),
                                  textStyle: TextStyle(
                                    fontWeight: FontWeightHelper.medium,
                                    color: ColorsManager.mainWhite,
                                    fontSize: 20.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              // Default state - show loading or prompt to login
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Please wait while we load your profile...'),
                    SizedBox(height: 16),
                    CircularProgressIndicator(),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
