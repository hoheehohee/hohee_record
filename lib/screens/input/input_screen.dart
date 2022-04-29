import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hohee_record/constants/common_size.dart';
import 'package:hohee_record/widgets/multi_image_select.dart';

/**
 * 중고거래 아이템 등록 페이지
 */
class InputScreen extends StatefulWidget {
  const InputScreen({Key? key}) : super(key: key);

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("중고거래 글쓰기"),
        leading: TextButton(
            onPressed: () {
              context.beamBack();
            },
            child: Text(
              '뒤로',
              style: Theme.of(context).textTheme.bodyText2
            )
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              '완료',
              style: Theme.of(context).textTheme.bodyText2
            ),
          )
        ],
      ),
      body: ListView( // create new item layout
        children: const [
          MultiImageSelect(),
          Divider(
            height: 1,
            color: Colors.grey,
            thickness: 1,
            indent: common_padding,
            endIndent: common_padding,
          ),
        ],
      )
    );
  }
}

