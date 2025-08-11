import 'package:flutter/material.dart';
import 'package:flutter_shamstore/core/routing/routes.dart';
import 'package:flutter_shamstore/features/cart/ui/my_cart_screen.dart';
import 'package:flutter_shamstore/features/cart/ui/widget_payment/delivery_address.dart';
import 'package:flutter_shamstore/features/cart/ui/widget_payment/payment.dart';
import 'package:flutter_shamstore/features/cart/ui/widget_payment/payment_successful.dart';
import 'package:flutter_shamstore/features/home/home_screen.dart';
import 'package:flutter_shamstore/features/login/ui/forget_password.dart';
import 'package:flutter_shamstore/features/login/ui/login_screen.dart';
import 'package:flutter_shamstore/features/login/ui/reset_password.dart';
import 'package:flutter_shamstore/features/my_order/ui/my_order_screen.dart';
import 'package:flutter_shamstore/features/navigate/navigate_menu.dart';
import 'package:flutter_shamstore/features/onboarding/on_boarding.dart';
import 'package:flutter_shamstore/features/settings/settings_screen.dart';
import 'package:flutter_shamstore/features/sign_up/sign_up_screen.dart';
import 'package:flutter_shamstore/features/sign_up/ui/confirm_email.dart';
import 'package:flutter_shamstore/examples/add_to_cart_example.dart';
import 'package:flutter_shamstore/examples/view_cart_example.dart';
import 'package:flutter_shamstore/examples/add_to_cart_complete_example.dart';
import 'package:flutter_shamstore/features/notifications/ui/screens/notifications_screen.dart';
import 'package:flutter_shamstore/features/notifications/ui/screens/notification_settings_screen.dart';
import 'package:flutter_shamstore/features/login/ui/enter_reset_code.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    //final arguments = settings.arguments;
    switch (settings.name) {
      case Routes.onboarding1:
        return MaterialPageRoute(builder: (_) => OnBoarding1());
      case Routes.signupScreen:
        return MaterialPageRoute(builder: (_) => SignUpScreen());
      case Routes.navigationMenu:
        return MaterialPageRoute(builder: (_) => NavigationMenu());
      case Routes.homeScreen:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case Routes.myOrder:
        return MaterialPageRoute(builder: (_) => MyOrderScreen());
      case Routes.mycartscreen:
        return MaterialPageRoute(builder: (_) => MyCartScreen());
      case Routes.deliveryaddress:
        return MaterialPageRoute(builder: (_) => DeliveryAddress());
      case Routes.paymentscreen:
        return MaterialPageRoute(builder: (_) => PaymentScreen());
      case Routes.paymentsucc:
        return MaterialPageRoute(builder: (_) => PaymentSuccessful());
      case Routes.sttingsscreen:
        return MaterialPageRoute(builder: (_) => SettingsScreen());
      case Routes.loginscreen:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case Routes.forgetpassword:
        return MaterialPageRoute(builder: (_) => ForgetPassword());
      case Routes.resetPassword:
        return MaterialPageRoute(
          builder: (_) {
            final args = settings.arguments as Map<String, String>;
            return ResetPassword(email: args['email']!, token: args['token']!);
          },
        );
      case Routes.confirmemail:
        return MaterialPageRoute(builder: (_) => ConfirmEmail());
      case Routes.addToCartExample:
        return MaterialPageRoute(builder: (_) => const AddToCartExample());
      case Routes.viewCartExample:
        return MaterialPageRoute(builder: (_) => const ViewCartExample());
      case Routes.addToCartCompleteExample:
        return MaterialPageRoute(
          builder: (_) => const AddToCartCompleteExample(),
        );
      case Routes.notificationsScreen:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());
      case Routes.notificationSettingsScreen:
        return MaterialPageRoute(
          builder: (_) => const NotificationSettingsScreen(),
        );
      case Routes.enterResetCode:
        return MaterialPageRoute(
          builder: (_) {
            final args = settings.arguments as Map<String, String>;
            return EnterResetCode(email: args['email']!);
          },
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route definde for ${settings.name}')),
          ),
        );
    }
  }
}
