import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green[100],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ExtendedImage.asset(
              'assets/imgs/dio.png',
              width: 200,
              height: 200,
            ),
            const CircularProgressIndicator(
              color: Colors.green,
            )
          ],
        ),
      ),
    );
  }
}
