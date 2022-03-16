import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hohee_record/router/locations.dart';
import 'package:hohee_record/screens/splash_screen.dart';
import 'package:hohee_record/states/user_provider.dart';
import 'package:hohee_record/utils/logger.dart';
import 'package:provider/provider.dart';

final _routerDelegate = BeamerDelegate(
  guards: [
    BeamGuard(
      pathPatterns: ['/'],
      check: (BuildContext context,
          BeamLocation<RouteInformationSerializable<dynamic>> state) {
        return context.read<UserProvider>().userState;
        // return true;
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

  Provider.debugCheckInvalidValueType = null;
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
          duration: const Duration(milliseconds: 300),
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
    return ChangeNotifierProvider<UserProvider>(
      create: (BuildContext context) {
        return UserProvider();
      },
      child: MaterialApp.router(
        theme: ThemeData(
          primarySwatch: Colors.green,
          primaryColorLight: Colors.green[100],
          fontFamily: 'Bmjua',
          hintColor: Colors.grey[350],
          textTheme: const TextTheme(
            headline4: TextStyle(
              fontFamily: 'Bmjua',
            ),
            button: TextStyle(
              color: Colors.white,
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              backgroundColor: Colors.green,
              primary: Colors.white,
              minimumSize: const Size(48, 48),
            ),
          ),
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.green,
            highlightColor: Colors.green[50],
          ),
          appBarTheme: const AppBarTheme(
            elevation: 2,
            backgroundColor: Colors.green,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            selectedItemColor: Colors.black87,
            unselectedItemColor: Colors.black54,
          ),
        ),
        routeInformationParser: BeamerParser(),
        routerDelegate: _routerDelegate,
      ),
    );
  }
}
