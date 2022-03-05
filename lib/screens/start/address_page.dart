import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddressPage extends StatelessWidget {
  const AddressPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            decoration: InputDecoration(
              hintText: '도로명으로 검색',
              hintStyle: TextStyle(color: Theme.of(context).hintColor),
              border: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blueGrey,
                ),
              ),
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.grey,
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 24,
                minHeight: 24,
              ),
            ),
          ),
          TextButton.icon(
            onPressed: () {},
            // icon: const Icon(
            //   CupertinoIcons.compass,
            //   color: Colors.white,
            //   size: 18,
            // ),
            icon: const Icon(
              Icons.gps_fixed,
              color: Colors.white,
              size: 18,
            ),
            label: Text(
              '현재위치로 찾기',
              style: Theme.of(context).textTheme.button,
            ),
            style: TextButton.styleFrom(
              minimumSize: Size(10, 48),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('address index $index'),
                  subtitle: Text('subtitle index $index',),
                );
              },
              itemCount: 30,
            ),
          )
        ],
      ),
    );
  }
}
