import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hohee_record/data/AddressModel.dart';
import 'package:hohee_record/screens/start/address_service.dart';

import '../../constants/common_size.dart';

class AddressPage extends StatefulWidget {
  AddressPage({Key? key}) : super(key: key);

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  TextEditingController _addressController = TextEditingController();
  AddressModel? _addressModel;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum:
          const EdgeInsets.only(left: common_padding, right: common_padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _addressController,
            onFieldSubmitted: (text) async {
              _addressModel = await AddressService().searchAddressByStr(text);
              setState(() {});
            },
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
            onPressed: () {
              final text = _addressController.text;
              if (text.isNotEmpty) {
                AddressService().searchAddressByStr(text);
              }
            },
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
            label: const Text(
              '현재위치로 찾기',
            ),
            style: TextButton.styleFrom(
              minimumSize: Size(10, 48),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: common_sm_padding),
              itemBuilder: (context, index) {
                if (_addressModel == null ||
                    _addressModel!.result == null ||
                    _addressModel!.result!.items == null ||
                    _addressModel!.result!.items![index].address == null) {
                  return Container();
                }
                return ListTile(
                  title: Text(
                      _addressModel!.result!.items![index].address!.road ?? ""),
                  subtitle: Text(
                      _addressModel!.result!.items![index].address!.parcel ??
                          ""),
                );
              },
              itemCount: (_addressModel == null ||
                      _addressModel!.result == null ||
                      _addressModel!.result!.items == null)
                  ? 0
                  : _addressModel!.result!.items!.length,
            ),
          )
        ],
      ),
    );
  }
}
