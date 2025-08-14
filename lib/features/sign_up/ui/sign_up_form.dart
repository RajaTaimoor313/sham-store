import 'package:flutter/material.dart';
import 'package:flutter_shamstore/core/helpers/spacing.dart';
import 'package:flutter_shamstore/core/widgets/app_text_form_field.dart';
import 'package:flutter_shamstore/core/localization/localization_helper.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => SignUpFormState();
}

class SignUpFormState extends State<SignUpForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Getters to expose controllers
  TextEditingController get usernameController => _usernameController;
  TextEditingController get contactController => _contactController;
  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  TextEditingController get confirmPasswordController =>
      _confirmPasswordController;

  @override
  void dispose() {
    _usernameController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return context.tr('email_required');
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return context.tr('enter_valid_email');
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return context.tr('password_required');
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return context.tr('confirm_password_required');
    }
    if (value != _passwordController.text) {
      return context.tr('passwords_do_not_match');
    }
    return null;
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return context.tr('field_required').replaceFirst('%s', fieldName);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextFormField(
          labelText: context.tr('name'),
          prefixIcon: const Icon(Icons.person),
          hintText: context.tr('enter_name'),
          controller: _usernameController,
          validator: (value) => _validateRequired(value, context.tr('name')),
        ),
        verticalspace(15),
        AppTextFormField(
          labelText: context.tr('contact'),
          prefixIcon: const Icon(Icons.phone),
          hintText: context.tr('enter_contact_number'),
          controller: _contactController,
          validator: (value) => _validateRequired(value, context.tr('contact')),
        ),
        verticalspace(15),
        AppTextFormField(
          labelText: context.tr('email'),
          prefixIcon: const Icon(Icons.email),
          hintText: context.tr('enter_email'),
          controller: _emailController,
          validator: _validateEmail,
        ),
        verticalspace(15),
        AppTextFormField(
          labelText: context.tr('new_password'),
          prefixIcon: const Icon(Icons.lock),
          isObscureText: true,
          hintText: context.tr('enter_new_password'),
          controller: _passwordController,
          validator: _validatePassword,
        ),
        verticalspace(15),
        AppTextFormField(
          labelText: context.tr('confirm_password'),
          prefixIcon: const Icon(Icons.lock),
          isObscureText: true,
          hintText: context.tr('enter_confirm_password'),
          controller: _confirmPasswordController,
          validator: _validateConfirmPassword,
        ),
      ],
    );
  }
}
