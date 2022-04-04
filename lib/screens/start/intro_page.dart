import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:hohee_record/states/user_provider.dart';
import 'package:provider/provider.dart';

import '../../constants/common_size.dart';
import '../../utils/logger.dart';

class IntroPage extends StatelessWidget {
  IntroPage({Key? key}) : super(key: key);

  void onButtonClick() {}

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        Size size = MediaQuery.of(context).size;

        final imgWidthSize = size.width - 32;
        final sizeOfPosImg = imgWidthSize * 0.1;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: common_padding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Hohee 마켓',
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                SizedBox(
                  width: imgWidthSize,
                  height: imgWidthSize,
                  child: Stack(
                    children: [
                      ExtendedImage.asset('assets/imgs/carrot_intro.png'),
                      Positioned(
                        width: sizeOfPosImg,
                        left: imgWidthSize * 0.45,
                        top: imgWidthSize * 0.45,
                        height: sizeOfPosImg,
                        child: ExtendedImage.asset(
                          'assets/imgs/carrot_intro_pos.png',
                        ),
                      ),
                    ],
                  ),
                ),
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
                      onPressed: () async {
                        context.read<PageController>().animateToPage(
                              1,
                              duration: const Duration(
                                milliseconds: 500,
                              ),
                              curve: Curves.ease,
                            );
                        logger.d('on Text button clicked!!');
                      },
                      child: const Text(
                        '내 동네 설정하고 시작하기',
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
