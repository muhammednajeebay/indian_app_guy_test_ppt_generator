import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indian_app_guy_test_ppt_generator/core/constants/app_constants.dart';
import 'package:indian_app_guy_test_ppt_generator/core/utils/logout_alert.dart';
import 'package:indian_app_guy_test_ppt_generator/presentation/blocs/theme/theme_bloc.dart';
import 'package:indian_app_guy_test_ppt_generator/presentation/blocs/theme/theme_event.dart';
import 'package:indian_app_guy_test_ppt_generator/presentation/blocs/theme/theme_state.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(AppConstants.appName),
      actions: [
        BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            return Switch(
              value: state.themeMode == ThemeMode.dark,
              onChanged: (value) {
                context.read<ThemeBloc>().add(
                  ThemeChanged(value ? ThemeMode.dark : ThemeMode.light),
                );
              },
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            fnShowLogoutAlertDialogue(context);
          },
        ),
      ],
    );
  }
}
