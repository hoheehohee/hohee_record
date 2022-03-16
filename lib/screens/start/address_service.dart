import 'package:dio/dio.dart';
import 'package:hohee_record/data/AddressModel.dart';

import 'package:hohee_record/utils/logger.dart';

import '../../constants/keys.dart';
import '../../data/AddressGeocoderModel.dart';

class AddressService {
  Future<AddressModel> searchAddressByStr(String text) async {
    final formData = {
      'key': VWORLD_KEY,
      'request': 'search',
      'size': 30,
      'page': 1,
      'query': text,
      'type': 'ADDRESS',
      'category': 'ROAD',
    };

    final response = await Dio()
        .get('http://api.vworld.kr/req/search', queryParameters: formData)
        .catchError(
      (e) {
        logger.e(e);
      },
    );

    AddressModel addressModel =
        AddressModel.fromJson(response.data['response']);
    return addressModel;
  }

  Future<List<AddressGeocoderModel>> findAddressByCoordinate(
      {required double log, required double lat}) async {
    final List<Map<String, dynamic>> formData = <Map<String, dynamic>>[];

    formData.add({
      'key': VWORLD_KEY,
      'service': 'address',
      'request': 'getAddress',
      'type': 'PARCEL',
      'point': '$log, $lat'
    });

    formData.add({
      'key': VWORLD_KEY,
      'service': 'address',
      'request': 'getAddress',
      'type': 'PARCEL',
      'point': '${log - 0.01}, $lat'
    });

    formData.add({
      'key': VWORLD_KEY,
      'service': 'address',
      'request': 'getAddress',
      'type': 'PARCEL',
      'point': '${log + 0.01}, $lat'
    });

    formData.add({
      'key': VWORLD_KEY,
      'service': 'address',
      'request': 'getAddress',
      'type': 'PARCEL',
      'point': '$log, ${lat - 0.01}'
    });

    formData.add({
      'key': VWORLD_KEY,
      'service': 'address',
      'request': 'getAddress',
      'type': 'PARCEL',
      'point': '$log, ${lat + 0.01}'
    });

    List<AddressGeocoderModel> addresses = [];

    for(Map<String, dynamic> formData in formData) {
      final response = await Dio()
          .get('http://api.vworld.kr/req/address', queryParameters: formData)
          .catchError((e) {
        logger.e(e);
      });

      AddressGeocoderModel addressModel = AddressGeocoderModel.fromJson(response.data['response']);
      if (response.data['response']['status'] == 'OK') {
        addresses.add(addressModel);
      }
    }

    return addresses;
  }
}
