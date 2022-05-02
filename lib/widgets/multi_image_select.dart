import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import '../constants/common_size.dart';

class MultiImageSelect extends StatelessWidget {
  const MultiImageSelect({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        Size _size = MediaQuery.of(context).size;
        var imageSize = (_size.width / 3) - common_padding * 2;
        var imageCorner = 16.0;

        return SizedBox(
          height: _size.width / 3,
          width: _size.width,
          child: ListView(
            scrollDirection: Axis.horizontal, // 좌우 스크롤
            children: [
              Padding(
                padding: const EdgeInsets.all(common_padding),
                child: Container(
                  width: imageSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(imageCorner),
                    border: Border.all(color: Colors.grey, width: 1),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.camera_alt,
                        color: Colors.grey,
                      ),
                      Text(
                        '0/10',
                        style: Theme.of(context).textTheme.subtitle2,
                      )
                    ],
                  ),
                ),
              ),
              ...List.generate(
                20,
                (index) => Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        right: common_padding,
                        top: common_padding,
                        bottom: common_padding,
                      ),
                      child: ExtendedImage.network(
                        'https://picsum.photos/100',
                        width: imageSize,
                        borderRadius: BorderRadius.circular(imageCorner),
                        shape: BoxShape.rectangle,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      width: 40,
                      height: 40,
                      child: IconButton(
                        padding: const EdgeInsets.all(8),
                        onPressed: () {},
                        icon: const Icon(Icons.remove_circle),
                        color: Colors.black54,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
