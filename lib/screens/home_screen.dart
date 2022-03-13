import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hohee_record/states/user_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              context.read<UserProvider>().setUserAuth(false);
              context.beamToNamed('/');
            },
            icon: Icon(Icons.logout),
          )
        ],
      ),
    );
  }
}
