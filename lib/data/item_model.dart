import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class ItemModel {
  /// late는 데이터를 나중에 데이터를 꼭 넣겠다는 약속하는 키워드
  /// late를 사용하면 사용된 변수들은 꼭 사용전에 데이터를 입력해줘야함.
  /// option + shift + D

  late String itemKey;
  late String userKey;
  late String title;
  late String category;
  late String detail;
  late String address;
  late num price;
  late bool negotiable;
  late List<String> imageDownloadUrls;
  late GeoFirePoint geoFirePoint;
  late DateTime createdDate;
  late DocumentReference? reference;

  ItemModel({
    required this.itemKey,
    required this.userKey,
    required this.title,
    required this.category,
    required this.detail,
    required this.address,
    required this.price,
    required this.negotiable,
    required this.imageDownloadUrls,
    required this.geoFirePoint,
    required this.createdDate,
    this.reference,
  });

  ItemModel.fromJson(Map<String, dynamic> json, this.itemKey, this.reference) {
    userKey = json['userKey'] ?? "";
    title = json['title'] ?? "";
    category = json['category'] ?? "none";
    detail = json['detail'] ?? "";
    address = json['address'] ?? "";
    price = json['price'] ?? 0;
    negotiable = json['negotiable'] ?? false;
    imageDownloadUrls = json['imageDownloadUrls'] != null ? json['imageDownloadUrls'].cast<String>() : [];
    geoFirePoint = GeoFirePoint((json['geoFirePoint']['geopoint']).latitude,
        (json['geoFirePoint']['geopoint']).longitude);
    createdDate = json['createDate'] == null
        ?  DateTime.now().toUtc()
        : (json['createDate'] as Timestamp).toDate();
  }

  ItemModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data()!, snapshot.id, snapshot.reference);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userKey'] = userKey;
    map['title'] = title;
    map['category'] = category;
    map['detail'] = detail;
    map['address'] = address;
    map['price'] = price;
    map['negotiable'] = negotiable;
    map['imageDownloadUrls'] = imageDownloadUrls;
    map['geoFirePoint'] = geoFirePoint.data;
    map['createdDate'] = createdDate;
    map['reference'] = reference;
    return map;
  }
}

