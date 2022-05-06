import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../constants/common_size.dart';

class MultiImageSelect extends StatefulWidget {
  MultiImageSelect({
    Key? key,
  }) : super(key: key);

  @override
  State<MultiImageSelect> createState() => _MultiImageSelectState();
}

class _MultiImageSelectState extends State<MultiImageSelect> {
  List<Uint8List> _images = [];
  bool _isPickingImages = false;

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
                child: InkWell(
                  onTap: () async {
                    _isPickingImages = true;
                    setState(() {});
                    final ImagePicker _picker = ImagePicker();
                    final List<XFile>? images = await _picker.pickMultiImage(
                        imageQuality: 10); // Pick multiple images

                    if (images != null && images.isNotEmpty) {
                      _images.clear();
                      images.forEach((xfile) async {
                        _images.add(await xfile.readAsBytes());
                      });
                    }

                    _isPickingImages = false;
                    setState(() {});
                  },
                  child: Container(
                    width: imageSize,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(imageCorner),
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    child: _isPickingImages
                        ? Padding(
                          padding: EdgeInsets.all(imageSize / 3),
                          child: const CircularProgressIndicator(),
                        )
                        : Column(
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
              ),
              ...List.generate(
                _images.length,
                (index) => Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        right: common_padding,
                        top: common_padding,
                        bottom: common_padding,
                      ),
                      child: ExtendedImage.memory(
                        _images[index],
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
                        onPressed: () {
                          _images.removeAt(index);
                          setState(() {});
                        },
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
