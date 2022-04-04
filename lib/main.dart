import 'package:beamer/beamer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hohee_record/router/locations.dart';
import 'package:hohee_record/screens/splash_screen.dart';
import 'package:hohee_record/screens/start_screen.dart';
import 'package:hohee_record/states/user_provider.dart';
import 'package:hohee_record/utils/logger.dart';
import 'package:provider/provider.dart';

final _routerDelegate = BeamerDelegate(
  guards: [
    BeamGuard(
      pathPatterns: ['/'],
      check: (context, location) {
        return context.read<UserProvider>().user != null;
        // return true;
      },
      beamToNamed: (origin, target) => '/auth',
      // showPage: BeamPage(child: StartScreen())
    ),
  ],
  locationBuilder: (routeInformation, _) => HomeLocation(routeInformation),
  // locationBuilder: BeamerLocationBuilder(
  //   beamLocations: [
  //     HomeLocation(),
  //     AuthLocation(),
  //   ],
  // ),
  initialPath: '/home'
);

void main() async {
  logger.d("hohee app start");
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
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
    } else if (snapshot.connectionState == ConnectionState.done) {
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
    logger.d("hoheeApp start");
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
            subtitle1: TextStyle(color: Colors.black87, fontSize: 18),
            subtitle2: TextStyle(color: Colors.grey, fontSize: 13),
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
