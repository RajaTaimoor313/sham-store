import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shamstore/core/themina/colors.dart';
import 'package:flutter_shamstore/features/cart/ui/my_cart_screen.dart';
import 'package:flutter_shamstore/features/home/home_screen.dart';
import 'package:flutter_shamstore/features/my_order/ui/my_order_screen.dart';
import 'package:flutter_shamstore/features/settings/settings_screen.dart';
import 'package:flutter_shamstore/core/localization/localization_helper.dart';
import 'package:flutter_shamstore/core/localization/language_bloc.dart';

// -------- Bloc Section --------

// Events
abstract class NavigationEvent {}

class NavigationIndexChanged extends NavigationEvent {
  final int newIndex;
  NavigationIndexChanged(this.newIndex);
}

// State
class NavigationState {
  final int selectedIndex;
  NavigationState(this.selectedIndex);
}

// Bloc
class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationState(0)) {
    on<NavigationIndexChanged>((event, emit) {
      emit(NavigationState(event.newIndex));
    });
  }
}

// -------- UI Section --------

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  static  List<Widget> screens = [
    HomeScreen(),
    MyOrderScreen(),
    MyCartScreen(),
    SettingsScreen(),
  ];

  static const Color selectedColor = ColorsManager.mainBlue;
  static const Color unselectedColor = ColorsManager.mainGrey;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NavigationBloc(),
      child: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          return BlocBuilder<LanguageBloc, LanguageState>(
            builder: (context, languageState) {
              return Scaffold(
                body: screens[state.selectedIndex],
                bottomNavigationBar: Container(
              decoration: BoxDecoration(
                color: ColorsManager.mainWhite,
                border: Border(
                  top: BorderSide(
                    color: ColorsManager.mainBlue,
                    width: 1.5.h,
                  )
                )
              ),
              child: NavigationBarTheme(
                data: NavigationBarThemeData(
                  indicatorColor: ColorsManager.lightBlue, // إزالة خلفية التحديد
                  labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
                    (states) {
                      if (states.contains(WidgetState.selected)) {
                        return const TextStyle(
                          color: ColorsManager.mainBlue,
                          fontWeight: FontWeight.w600,
                        );
                      }
                      return const TextStyle(color: ColorsManager.mainGrey);
                    },
                  ),
                  iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
                    (states) {
                      if (states.contains(WidgetState.selected)) {
                        return const IconThemeData(color: ColorsManager.mainBlue);
                      }
                      return const IconThemeData(color: ColorsManager.mainGrey);
                    },
                  ),
                ),
                child: NavigationBar(
                  backgroundColor: ColorsManager.mainWhite,
                  height: 72.h,
                  elevation: 0,
                  selectedIndex: state.selectedIndex,
                  onDestinationSelected: (index) {
                    context.read<NavigationBloc>().add(NavigationIndexChanged(index));
                  },
                  destinations: [
                    NavigationDestination(icon: Icon(Icons.home), label: context.tr('home')),
                    NavigationDestination(icon: Icon(Icons.shopping_bag), label: context.tr('orders')),
                    NavigationDestination(icon: Icon(Icons.shopping_cart), label: context.tr('cart')),                 
                    NavigationDestination(icon: Icon(Icons.settings), label: context.tr('settings')),
                  ],
                ),
              ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
