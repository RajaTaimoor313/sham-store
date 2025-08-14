import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shamstore/features/cart/ui/my_cart_screen.dart';
import 'package:flutter_shamstore/features/my_order/ui/my_order_screen.dart';
import 'package:flutter_shamstore/features/settings/ui/widgets/favourites.dart';
import 'package:flutter_shamstore/features/settings/ui/widgets/my_change_password.dart';
import 'package:flutter_shamstore/features/settings/ui/widgets/my_payment_method.dart';
import 'package:flutter_shamstore/features/settings/ui/widgets/profile.dart';
import 'package:flutter_shamstore/core/localization/language_bloc.dart';
import 'package:flutter_shamstore/core/localization/localization_helper.dart';
import 'package:flutter_shamstore/features/auth/logic/auth_bloc.dart';
import 'package:flutter_shamstore/core/routing/routes.dart';

class SettingsListTile extends StatefulWidget {
  const SettingsListTile({super.key});

  @override
  State<SettingsListTile> createState() => _SettingsListTileState();
}

class _SettingsListTileState extends State<SettingsListTile> {
  bool isDarkMode = false; // حالة الوضع الليلي

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, state) {
        return Column(
          children: [
            _buildTile(
              title: context.tr('profile'),
              icon: Icons.person_outline,
            ),
            _buildTile(
              title: context.tr('favourites'),
              icon: Icons.favorite_outline,
            ),
            _buildTile(
              title: context.tr('cart'),
              icon: Icons.shopping_cart_outlined,
            ),
            _buildTile(
              title: context.tr('orders'),
              icon: Icons.shopping_bag_outlined,
            ),
            _buildTile(
              title: context.tr('payment_method'),
              icon: Icons.payment_outlined,
            ),
            _buildTile(
              title: context.tr('notifications'),
              icon: Icons.notifications_outlined,
            ),
            _buildTile(
              title: context.tr('change_password'),
              icon: Icons.lock_outline,
            ),
            _buildTile(
              title: context.tr('feedback'),
              icon: Icons.feedback_outlined,
            ),

            ListTile(
              title: Text(
                context.tr('language'),
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
              ),
              leading: Icon(Icons.language_outlined),
              trailing: Icon(Icons.arrow_forward_ios, size: 16.sp),
              onTap: () => _showLanguageDialog(context),
            ),

            ListTile(
              title: Text(
                context.tr('dark_mode'),
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
              ),
              leading: Icon(Icons.dark_mode_outlined),
              trailing: Switch(value: false, onChanged: (value) {}),
            ),

            ListTile(
              title: Text(
                context.tr('support'),
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
              ),
              leading: Icon(Icons.card_giftcard_outlined),
              onTap: () {},
            ),
            ListTile(
              title: Text(
                context.tr('rate_us'),
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
              ),
              leading: Icon(Icons.sentiment_satisfied),
              onTap: () {},
            ),
            ListTile(
              title: Text(
                context.tr('share_app'),
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
              ),
              leading: Icon(Icons.share),
              onTap: () {},
            ),
            ListTile(
              title: Text(
                context.tr('logout'),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.red,
                ),
              ),
              leading: Icon(Icons.login_outlined, color: Colors.red),
              onTap: () => _showLogoutDialog(context),
            ),
          ],
        );
      },
    );
  }

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

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            context.tr('select_language'),
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.language),
                title: Text(
                  context.tr('english'),
                  style: TextStyle(fontSize: 16.sp),
                ),
                onTap: () {
                  context.read<LanguageBloc>().add(const ChangeLanguage('en'));
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.tr('language_changed_english')),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.language),
                title: Text(
                  context.tr('arabic'),
                  style: TextStyle(fontSize: 16.sp),
                ),
                onTap: () {
                  context.read<LanguageBloc>().add(const ChangeLanguage('ar'));
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.tr('language_changed_arabic')),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
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
          ],
        );
      },
    );
  }

  Widget _buildTile({required String title, required IconData icon}) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
      ),
      leading: Icon(icon),
      trailing: Icon(Icons.arrow_forward_ios, size: 16.sp),
      onTap: () {
        // Use translation keys for navigation logic
        if (title == context.tr('favourites')) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => FavouritesScreen()),
          );
        } else if (title == context.tr('cart')) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => MyCartScreen()),
          );
        } else if (title == context.tr('orders')) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => MyOrderScreen()),
          );
        } else if (title == context.tr('payment_method')) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MyPaymentMethod()),
          );
        } else if (title == context.tr('change_password')) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MyChangePassword()),
          );
        } else if (title == context.tr('notifications')) {
          Navigator.pushNamed(context, Routes.notificationsScreen);
        } else if (title == context.tr('profile')) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => MyProfile()),
          );
        } else if (title == context.tr('feedback')) {
          Navigator.pushNamed(context, Routes.feedbackScreen);
        }
      },
    );
  }
}
