import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import '../constants/common_size.dart';

class ImageItem extends StatelessWidget {
  const ImageItem({
    Key? key,
    this.imageSize = 0,
    this.imageCorner = 0,
    this.removeAt,
    required this.item,
    required this.animation,
  }) : super(key: key);

  final Uint8List item;
  final double imageSize;
  final double imageCorner;
  final VoidCallback? removeAt;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: animation,
      axis: Axis.horizontal,
      axisAlignment: -3,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              right: common_padding,
              top: common_padding,
              bottom: common_padding,
            ),
            child: ExtendedImage.memory(
              item,
              width: imageSize,
              height: imageSize,
              fit: BoxFit.cover,
              loadStateChanged: (state) {
                switch (state.extendedImageLoadState) {
                  case LoadState.loading:
                    return Container(
                      width: imageSize,
                      height: imageSize,
                      padding: EdgeInsets.all(imageSize / 3),
                      child: const CircularProgressIndicator(),
                    );
                  case LoadState.completed:
                    return null;
                  case LoadState.failed:
                  // TODO: Handle this case.
                    return const Icon(Icons.cancel);
                }
              },
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
              onPressed: removeAt,
              icon: const Icon(Icons.remove_circle),
              color: Colors.black54,
            ),
          )
        ],
      ),
    );
  }
}
