import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magicslides_ppt_assist/presentation/blocs/auth/auth_bloc.dart';
import 'package:magicslides_ppt_assist/presentation/blocs/auth/auth_event.dart';
import 'package:magicslides_ppt_assist/presentation/screens/auth/login_screen.dart';

Future<dynamic> fnShowLogoutAlertDialogue(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Logout'),
      content: const Text('Are you sure you want to logout?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            context.read<AuthBloc>().add(AuthLogoutRequested());
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          },
          child: const Text('Logout', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}
