import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shamstore/core/themina/colors.dart';
import 'package:flutter_shamstore/features/settings/ui/settings_list_tile.dart';
import 'package:flutter_shamstore/core/localization/localization_helper.dart';
import 'package:flutter_shamstore/core/localization/language_bloc.dart';
import 'package:flutter_shamstore/core/routing/routes.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ColorsManager.mainWhite,
            title: Text(
              context.tr('settings'),
              style: TextStyle(color: ColorsManager.mainBlue),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pushReplacementNamed(context, Routes.navigationMenu),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(children: [SettingsListTile()]),
              ),
            ),
          ),
        );
      },
    );
  }
}
