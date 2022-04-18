import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hohee_record/utils/logger.dart';

class UserService {
  Future firestoreTest() async {
    FirebaseFirestore.instance
        .collection('TESTING_COLLECTION')
        .add({'testing': 'testing value', 'number': 123123});
  }

  void firestoreReadTest() {
    /**
     * DocumentSnapshot<Map<String, dynamic>: firebase의 DocumentSnapshot 있는 JSON형테의 데이터를 map 형식으로 받는데
     * 이게 시간이 걸리기 때문에 Future를 통해서 받는다.
     */
    FirebaseFirestore.instance
        .collection('TESTING_COLLECTION')
        .doc('OVb9AHN9osjGT39kZWb6')
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> value) =>
            logger.d(value.data()));
  }
}
