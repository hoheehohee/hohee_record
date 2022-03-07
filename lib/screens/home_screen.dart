import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hohee_record/states/user_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextButton(
          onPressed: () {
            context.read<UserProvider>().setUserAuth(false);
            context.beamToNamed('/');
          },
          child: const Text("로그아웃"),
        ),
      ],
    ));
  }
}
