import 'package:flutter/material.dart';
import 'package:flutter_shamstore/core/helpers/spacing.dart';
import 'package:flutter_shamstore/core/widgets/app_text_form_field.dart';

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
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Getters to expose controllers
  TextEditingController get usernameController => _usernameController;
  TextEditingController get contactController => _contactController;
  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  TextEditingController get confirmPasswordController => _confirmPasswordController;

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
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextFormField(
          labelText: 'Username',
          prefixIcon: const Icon(Icons.person),
          hintText: 'Enter Username',
          controller: _usernameController,
          validator: (value) => _validateRequired(value, 'Username'),
        ),
        verticalspace(15),
        AppTextFormField(
          labelText: 'Contact No',
          prefixIcon: const Icon(Icons.phone),
          hintText: 'Enter Contact Number',
          controller: _contactController,
          validator: (value) => _validateRequired(value, 'Contact Number'),
        ),
        verticalspace(15),
        AppTextFormField(
          labelText: 'Email',
          prefixIcon: const Icon(Icons.email),
          hintText: 'Enter Email',
          controller: _emailController,
          validator: _validateEmail,
        ),
        verticalspace(15),
        AppTextFormField(
          labelText: 'Password',
          prefixIcon: const Icon(Icons.lock),
          isObscureText: true,
          hintText: 'Enter Password',
          controller: _passwordController,
          validator: _validatePassword,
        ),
        verticalspace(15),
        AppTextFormField(
          labelText: 'Confirm Password',
          prefixIcon: const Icon(Icons.lock),
          isObscureText: true,
          hintText: 'Re-enter Password',
          controller: _confirmPasswordController,
          validator: _validateConfirmPassword,
        ),
      ],
    );
  }
}
