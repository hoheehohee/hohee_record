import 'package:beamer/beamer.dart';
import 'package:extended_image/extended_image.dart';
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
  bool _suggestPriceSelected = false;

  final _divider = Divider(
    height: 1,
    color: Colors.grey[350],
    thickness: 1,
    indent: common_padding,
    endIndent: common_padding,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("중고거래 글쓰기"),
          leading: TextButton(
              onPressed: () {
                context.beamBack();
              },
              child: Text('뒤로', style: Theme.of(context).textTheme.bodyText2)),
          actions: [
            TextButton(
              onPressed: () {},
              child: Text('완료', style: Theme.of(context).textTheme.bodyText2),
            )
          ],
        ),
        body: ListView(
          // create new item layout
          children: [
            const MultiImageSelect(),
            _divider,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: common_padding),
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: '글 제목',
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                ),
              ),
            ),
            _divider,
            const ListTile(
              dense: true,
              title: Text('선택'),
              trailing: Icon(Icons.navigate_next),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: common_padding),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '얼마에 파시겠어요?',
                        prefixIcon: ImageIcon(
                          const ExtendedAssetImageProvider(
                              'assets/imgs/won.png'),
                          size: 20,
                          color: Colors.grey[350],
                        ),
                        prefixIconConstraints:
                            const BoxConstraints(maxWidth: 20),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: common_sm_padding),
                        border: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                      ),
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _suggestPriceSelected = !_suggestPriceSelected;
                    });
                  },
                  icon: Icon(
                    Icons.check_circle_outline,
                    color: _suggestPriceSelected
                        ? Theme.of(context).primaryColor
                        : Colors.black54,
                  ),
                  label: Text(
                    "가격제한 받기",
                    style: TextStyle(
                      color: _suggestPriceSelected
                          ? Theme.of(context).primaryColor
                          : Colors.black54,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    primary: Colors.black45,
                    backgroundColor: Colors.transparent,
                  ),
                )
              ],
            ),
          ],
        ));
  }
}
