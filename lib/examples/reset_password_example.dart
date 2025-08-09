import 'package:flutter/material.dart';
import 'package:flutter_shamstore/core/helpers/extensions.dart';
import 'package:flutter_shamstore/core/routing/routes.dart';

/// Example of how to navigate to the reset password screen
/// This would typically be called from an email link or after receiving a reset token
class ResetPasswordExample {
  /// Navigate to reset password screen with email and token
  /// 
  /// Example usage:
  /// ```dart
  /// ResetPasswordExample.navigateToResetPassword(
  ///   context,
  ///   email: 'user@example.com',
  ///   token: 'reset_token_from_email',
  /// );
  /// ```
  static void navigateToResetPassword(
    BuildContext context, {
    required String email,
    required String token,
  }) {
    context.pushNamed(
      Routes.resetPassword,
      arguments: {
        'email': email,
        'token': token,
      },
    );
  }

  /// Example of how this might be used in a deep link handler
  /// when user clicks on reset password link in email
  static void handleResetPasswordDeepLink(
    BuildContext context,
    String deepLinkUrl,
  ) {
    // Parse the deep link URL to extract email and token
    // Example URL: https://yourapp.com/reset-password?email=user@example.com&token=abc123
    final uri = Uri.parse(deepLinkUrl);
    final email = uri.queryParameters['email'];
    final token = uri.queryParameters['token'];

    if (email != null && token != null) {
      navigateToResetPassword(
        context,
        email: email,
        token: token,
      );
    } else {
      // Handle invalid deep link
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid reset password link'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}