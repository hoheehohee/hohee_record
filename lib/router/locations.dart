import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hohee_record/screens/start_screen.dart';
import 'package:hohee_record/screens/home_screen.dart';
import 'package:hohee_record/utils/logger.dart';

import '../screens/input/input_screen.dart';

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
          key: const ValueKey('auth'),
          title: 'auth In',
          child: StartScreen(),
        )
      else
        const BeamPage(
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
        const BeamPage(
          key: ValueKey('input'),
          child: InputScreen(),
        )
    ];
  }
}