import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

/**
 * create model to firestore
 */
class UserModel {

  /**
   * late는 데이터를 나중에 데이터를 꼭 넣겠다는 약속하는 키워드
   * late를 사용하면 사용된 변수들은 꼭 사용전에 데이터를 입력해줘야함.
   */
  late String userKey;
  late String phoneNumber;
  late String address;
  late GeoFirePoint geoFirePoint;
  late DateTime createDate;
  DocumentReference? reference;

  UserModel({
    required this.userKey,
    required this.phoneNumber,
    required this.address,
    required this.geoFirePoint,
    required this.createDate,
    this.reference
  });

  /**
   * model coding style 01
   */
  // UserModel.fromJson(Map<String, dynamic> json, this.userKey, this.reference) {
  //   phoneNumber = json['phoneNumber'];
  //   address = json['address'];
  //   geoFirePoint = GeoFirePoint((json['geoFirePoint']['geopoint']).latitude, (json['geoFirePoint']['geopoint']).longitude);
  //   createDate = json['createDate'] == null ?  DateTime.now().toUtc() : (json['createDate'] as Timestamp).toDate();
  // }

  /**
   * model coding style 02
   */
  UserModel.fromJson(Map<String, dynamic> json, this.userKey, this.reference)
      : phoneNumber = json['phoneNumber'],
        address = json['address'],
        geoFirePoint = GeoFirePoint((json['geoFirePoint']['geopoint']).latitude,
            (json['geoFirePoint']['geopoint']).longitude),
        createDate = json['createDate'] == null
            ?  DateTime.now().toUtc()
            : (json['createDate'] as Timestamp).toDate();

  /**
   * get saved user model from firestore (15:00)
   * user 정보 model
   */
  UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data()!, snapshot.id, snapshot.reference);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['phoneNumber'] = phoneNumber;
    map['address'] = address;
    map['geoFirePoint'] = geoFirePoint.data;
    map['createDate'] = createDate;
    return map;
  }
}