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

        return SizedBox(
          height: _size.width / 3,
          width: _size.width,
          child: ListView(
            scrollDirection: Axis.horizontal, // 좌우 스크롤
            children: [
              Padding(
                padding: const EdgeInsets.all(common_padding),
                child: Container(
                  width: (_size.width / 3) - common_padding * 2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
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
              Container(width: 100, color: Colors.blueAccent,),
              Container(width: 100, color: Colors.cyanAccent,),
              Container(width: 100, color: Colors.amberAccent,),
              Container(width: 100, color: Colors.blueAccent,),
              Container(width: 100, color: Colors.cyanAccent,),
            ],
          ),
        );
      },
    );
  }
}