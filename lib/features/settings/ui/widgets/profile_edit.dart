import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shamstore/core/helpers/spacing.dart';
import 'package:flutter_shamstore/core/routing/routes.dart';
import 'package:flutter_shamstore/core/themina/colors.dart';
import 'package:flutter_shamstore/core/themina/font_weight_help.dart';
import 'package:flutter_shamstore/core/widgets/app_text_form_field.dart';
import 'package:flutter_shamstore/core/widgets/text_button.dart';
import 'package:flutter_shamstore/features/auth/logic/auth_bloc.dart';

class MyProfileEdit extends StatefulWidget {
  const MyProfileEdit({super.key});

  @override
  State<MyProfileEdit> createState() => _MyProfileEditState();
}

class _MyProfileEditState extends State<MyProfileEdit> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController addressController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with empty values
    nameController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();
    addressController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          // إرجاع true للإشارة أن التعديل تم بنجاح
          Navigator.pop(context, true);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: ColorsManager.mainWhite,
                title: Text(
                  'Edit Profile',
                  style: TextStyle(color: ColorsManager.mainBlue),
                ),
                centerTitle: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pushReplacementNamed(context, Routes.sttingsscreen),
                ),
              ),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          // Load data into controllers when user is authenticated
          if (state is AuthAuthenticated) {
            // Only update controllers if they are empty (first time loading)
            if (nameController.text.isEmpty) {
              nameController.text = state.user.name ?? '';
              phoneController.text = state.user.phone ?? '';
              emailController.text = state.user.email ?? '';
              addressController.text = state.user.address ?? '';
            }
          }

          return Scaffold(
            appBar: AppBar(
              backgroundColor: ColorsManager.mainWhite,
              title: Text(
                'Edit Profile',
                style: TextStyle(color: ColorsManager.mainBlue),
              ),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pushReplacementNamed(context, Routes.sttingsscreen),
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(
                          'https://example.com/profile-image.png',
                        ),
                        backgroundColor: Colors.grey[200],
                      ),
                      verticalspace(10.h),
                      TextButton(
                        onPressed: () {
                          // تعديل الصورة لاحقًا
                        },
                        child: Text(
                          'Change',
                          style: TextStyle(
                            color: ColorsManager.mainBlue,
                            fontSize: 16.sp,
                            fontWeight: FontWeightHelper.medium,
                          ),
                        ),
                      ),
                      verticalspace(24.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                            AppTextFormField(
                              hintText: 'Enter your name',
                              controller: nameController,
                              prefixIcon: Icon(Icons.person),
                              labelText: 'User Name',
                            ),
                            verticalspace(15.h),
                            AppTextFormField(
                              hintText: 'Enter your phone',
                              controller: phoneController,
                              prefixIcon: Icon(Icons.mobile_friendly),
                              labelText: 'Contact No.',
                            ),
                            verticalspace(15.h),
                            AppTextFormField(
                              hintText: 'Enter your Email',
                              controller: emailController,
                              prefixIcon: Icon(Icons.message),
                              labelText: 'Email',
                            ),
                            verticalspace(15.h),
                            AppTextFormField(
                              hintText: 'Enter your Address (Optional)',
                              controller: addressController,
                              prefixIcon: Icon(Icons.location_on),
                              labelText: 'Address (Optional)',
                            ),
                            verticalspace(30.h),
                            Center(
                              child: AppTextButton(
                                onPressed: () {
                                  // Validate required fields before saving
                                  if (nameController.text.trim().isEmpty ||
                                      phoneController.text.trim().isEmpty ||
                                      emailController.text.trim().isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Please fill all required fields')),
                                    );
                                    return;
                                  }

                                  context.read<AuthBloc>().add(
                                        AuthUpdateProfileRequested(
                                          name: nameController.text.trim(),
                                          phone: phoneController.text.trim(),
                                          email: emailController.text.trim(),
                                          address: addressController.text.trim(),
                                        ),
                                      );
                                },
                                buttonText: 'Save',
                                textStyle: TextStyle(
                                  fontWeight: FontWeightHelper.medium,
                                  color: ColorsManager.mainWhite,
                                  fontSize: 20.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}