import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hohee_record/screens/start_screen.dart';
import 'package:hohee_record/screens/home_screen.dart';
import 'package:hohee_record/utils/logger.dart';

class HomeLocation extends BeamLocation<BeamState> {
  @override
  List<String> get pathPatterns => [
        '/home',
        '/auth',
      ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      if (state.uri.pathSegments.contains('auth'))
        BeamPage(
          key: ValueKey('auth'),
          title: 'auth In',
          child: StartScreen(),
        )
      else
        BeamPage(
          key: ValueKey('home'),
          title: 'home',
          child: HomeScreen(),
        )
    ];
  }
}

class InputLocation extends BeamLocation<BeamState> {
  @override
  // TODO: implement pathPatterns
  List<Pattern> get pathPatterns => ['/input'];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      ...HomeLocation().buildPages(context, state),
      if (state.pathPatternSegments.contains('input'))
        BeamPage(
            key: ValueKey('input'),
            child: Scaffold(
                appBar: AppBar(
                  title: const Text('Create New Item'),
                ),
                body: Container(color: Colors.white)))
    ];
  }
}

// class HomeLocation extends BeamLocation {
//   @override
//   List<BeamPage> buildPages(
//       BuildContext context, RouteInformationSerializable state) {
//     return [
//       const BeamPage(
//         child: HomeScreen(),
//         key: ValueKey('home'),
//       ),
//     ];
//   }
//
//   @override
//   List<Pattern> get pathPatterns => ['/'];
// }
//
// class AuthLocation extends BeamLocation {
//   @override
//   List<BeamPage> buildPages(
//       BuildContext context, RouteInformationSerializable state) {
//     return [
//       BeamPage(
//         child: StartScreen(),
//         key: ValueKey('auth'),
//       )
//     ];
//   }
//
//   @override
//   // TODO: implement pathPatterns
//   List<Pattern> get pathPatterns => ['/auth'];
// }
