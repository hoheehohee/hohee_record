import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import '../../utils/logger.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({Key? key}) : super(key: key);

  void onButtonClick() {}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('Hohee 마켓',
                style: Theme.of(context).textTheme.headline4!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    )),
            ExtendedImage.asset('assets/imgs/carrot_intro.png'),
            const Text(
              '우리 동네 중고 직거래 hohee 마켓',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
              'hohee마켓은 동네 직거래 마켓이에요.\n내 동네를 설정하고 시작해보세요.',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextButton(
                  onPressed: () {
                    logger.d('on Text button clicked!!');
                  },
                  child: Text(
                    '내 동네 설정하고 시작하기',
                    style: Theme.of(context).textTheme.button
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
