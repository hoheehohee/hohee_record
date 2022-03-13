import 'package:dio/dio.dart';
import 'package:hohee_record/data/AddressModel.dart';
import 'package:hohee_record/utils/logger.dart';

import '../../constants/keys.dart';

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

    final response = await Dio().get('http://api.vworld.kr/req/search', queryParameters: formData).catchError((e) {
      logger.e(e);
    },);

    AddressModel addressModel = AddressModel.fromJson(response.data['response']);
    return addressModel;
  }
}

