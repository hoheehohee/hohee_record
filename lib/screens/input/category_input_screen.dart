import 'package:flutter/material.dart';

class CategoryInputScreen extends StatelessWidget {
  const CategoryInputScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('카테고리 선택'),
      ),
      body: ListView.separated(
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(categorisKor[index]),
              onTap: () {

              },
            );
          },
          separatorBuilder: (context, index) {
            return Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey[300]
            );
          },
          itemCount: categorisKor.length),
    );
  }
}

const List<String> categorisKor = [
  '선택',
  '가구',
  '전자기기',
  '유아복',
  '스포츠',
  '여성',
  '남성',
  '메이크업'
];
