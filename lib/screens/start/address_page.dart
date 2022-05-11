import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hohee_record/constants/shared_pref_key.dart';
import 'package:hohee_record/data/address_geocoder_model.dart';
import 'package:hohee_record/data/address_model.dart';
import 'package:hohee_record/screens/start/address_service.dart';
import 'package:hohee_record/utils/logger.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '../../constants/common_size.dart';

class AddressPage extends StatefulWidget {
  AddressPage({Key? key}) : super(key: key);

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  TextEditingController _addressController = TextEditingController();

  AddressModel? _addressModel;
  List<AddressGeocoderModel> _addressGeocodeModelList = [];
  bool _isGettingLocation = false;

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

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
              _addressGeocodeModelList.clear();
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
            onPressed: () async {
              _addressModel = null;
              _addressController.text = '';
              _addressGeocodeModelList.clear();
              setState(() {
                _isGettingLocation = true;
              });
              Location location = new Location();

              bool _serviceEnabled;
              PermissionStatus _permissionGranted;
              LocationData _locationData;

              _serviceEnabled = await location.serviceEnabled();
              if (!_serviceEnabled) {
                _serviceEnabled = await location.requestService();
                if (!_serviceEnabled) {
                  return;
                }
              }

              _permissionGranted = await location.hasPermission();
              if (_permissionGranted == PermissionStatus.denied) {
                _permissionGranted = await location.requestPermission();
                if (_permissionGranted != PermissionStatus.granted) {
                  return;
                }
              }

              _locationData = await location.getLocation();
              List<AddressGeocoderModel> address = await AddressService().findAddressByCoordinate(
                  log: _locationData.longitude!,
                  lat: _locationData.latitude!,
              );
              _addressGeocodeModelList.addAll(address);

              logger.d(_addressGeocodeModelList);

              setState(() {
                _isGettingLocation = false;
              });
            },
            icon: _isGettingLocation
                ? const SizedBox(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                    height: 18,
                    width: 18,
                  )
                : const Icon(
                    Icons.gps_fixed,
                    color: Colors.white,
                    size: 18,
                  ),
            label: Text(
              _isGettingLocation ? '위치 정보 조회중...' : '현재위치로 찾기',
            ),
            style: TextButton.styleFrom(
              minimumSize: const Size(10, 48),
            ),
          ),
          if (_addressModel != null)
            Expanded(
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(vertical: common_sm_padding),
                itemBuilder: (context, index) {
                  if (_addressModel == null ||
                      _addressModel!.result == null ||
                      _addressModel!.result!.items == null ||
                      _addressModel!.result!.items![index].address == null) {
                    return Container();
                  }
                  return ListTile(
                    onTap: () {
                      _saveAddressAndGoToNextPage(
                        _addressModel!.result!.items![index].address!.road ?? "",
                        num.parse(_addressModel!.result!.items![index].point!.y ?? "0"),
                        num.parse(_addressModel!.result!.items![index].point!.x ?? "0"),
                      );
                    },
                    title: Text(
                        _addressModel!.result!.items![index].address!.road ??
                            ""),
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
            ),
          if (_addressGeocodeModelList.isNotEmpty)
            Expanded(
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(vertical: common_sm_padding),
                itemBuilder: (context, index) {
                  if (_addressGeocodeModelList[index].result == null ||
                      _addressGeocodeModelList[index].result!.isEmpty) {
                    return Container();
                  }
                  return ListTile(
                    onTap: () {
                      _saveAddressAndGoToNextPage(
                        _addressGeocodeModelList[index].result![0].text ?? "",
                        num.parse(_addressGeocodeModelList[index].input!.point!.y ?? "0"),
                        num.parse(_addressGeocodeModelList[index].input!.point!.x ?? "0"),
                      );
                    },
                    title: Text(
                        _addressGeocodeModelList[index].result![0].text ?? ""
                    ),
                    subtitle: Text(
                        _addressGeocodeModelList[index].result![0].zipcode ?? ""
                    ),
                  );
                },
                itemCount: _addressGeocodeModelList.length,
              ),
            )
        ],
      ),
    );
  }

  _saveAddressAndGoToNextPage(String address, num lat, num lon) async {
    _saveAddressOnSharedPreference(address, lat, lon);
    context.read<PageController>().animateToPage(
      2,
      duration: const Duration(
        milliseconds: 500,
      ),
      curve: Curves.ease,
    );
  }

  _saveAddressOnSharedPreference(String address, num lat, num lon) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(SHARED_ADDRESS, address);
    await prefs.setDouble(SHARED_LAT, lat.toDouble());
    await prefs.setDouble(SHARED_LON, lon.toDouble());
  }
}
