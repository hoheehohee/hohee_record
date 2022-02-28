import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hohee_record/router/locations.dart';
import 'package:hohee_record/screens/auth_screen.dart';
import 'package:hohee_record/screens/splash_screen.dart';
import 'package:hohee_record/utils/logger.dart';

final _routerDelegate = BeamerDelegate(
  guards: [
    BeamGuard(
      pathPatterns: ['/'],
      check: (BuildContext context,
          BeamLocation<RouteInformationSerializable<dynamic>> state) {
        return false;
      },
      beamToNamed: (origin, target) => '/auth',
      // showPage: const BeamPage(child: AuthScreen()),
    ),
  ],
  locationBuilder: BeamerLocationBuilder(
    beamLocations: [
      HomeLocation(),
      AuthLocation(),
    ],
  ),
);

void main() {
  logger.d("hohee app start");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 3), () => 100),
      builder: (context, snapshot) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 1000),
          child: _splashLoadingWidget(snapshot),
        );
      },
    );
  }

  StatelessWidget _splashLoadingWidget(AsyncSnapshot<Object?> snapshot) {
    if (snapshot.hasError) {
      return const Text('Error occur');
    } else if (snapshot.hasData) {
      return const HoheeApp();
    } else {
      return const SplashScreen();
    }
  }
}

class HoheeApp extends StatelessWidget {
  const HoheeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: BeamerParser(),
      routerDelegate: _routerDelegate,
    );
  }
}
