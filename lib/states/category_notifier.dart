import 'package:flutter/cupertino.dart';

CategoryNotifier categoryNotifier = CategoryNotifier();

class CategoryNotifier extends ChangeNotifier {
  String _selectedCategoryInEng = 'none';

  String get currentCategoryInEn => _selectedCategoryInEng;
  String get currentCategoryInKor => categoriesMapEngToKor[_selectedCategoryInEng]!;

  void setNewCatrogyWithEng(String newCategory) {
    if (categoriesMapEngToKor.keys.contains(newCategory)) {
      _selectedCategoryInEng = newCategory;
      notifyListeners();
    }
  }
  void setNewCatrogyWithKor(String newCategory) {
    if (categoriesMapEngToKor.values.contains(newCategory)) {
      _selectedCategoryInEng = categoriesMapKorToEng[newCategory]!;
      notifyListeners();
    }
  }
}

const Map<String, String> categoriesMapEngToKor = {
  'none': '선택',
  'furniture': '가구',
  'electronics': '전자기기',
  'kids': '유아복',
  'sports': '스포츠',
  'woman': '여성',
  'man': '남성',
  'makeup': '메이크업'
};

const Map<String, String> categoriesMapKorToEng = {
  '선택': 'none',
  '가구': 'furniture',
  '전자기기': 'electronics',
  '유아복': 'kids',
  '스포츠': 'sports',
  '여성': 'woman',
  '남성': 'man',
  '메이크업': 'makeup'
};

// 영문 키와 한글 value 위치 변경
// Map<String, String> categoriesMapKorToEng =
//     categoriesMapEngToKor.map((key, value) => MapEntry(value, key));