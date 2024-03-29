import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hohee_record/utils/logger.dart';

typedef RemovedItemBuilder<T> = Widget Function(
    Uint8List item, BuildContext context, Animation<double> animation);

class AnimateListModel<E> {
  AnimateListModel({
    required this.listKey,
    required this.removeItemBuilder,
    Iterable<E>? initialItems,
  })  : assert(listKey != null),
        assert(initialItems != null),
        _items = List<E>.from(initialItems ?? <E>[]);

  final List<E> _items;
  final RemovedItemBuilder<E> removeItemBuilder;
  GlobalKey<AnimatedListState> listKey;

  AnimatedListState get _animatedList => listKey.currentState!;

  Future<void> clear(key) async {
    listKey = key;
    _items.clear();
  }

  void insert(E item) async {
    int index = _items.length > 0 ? _items.length : 0;
    _items.add(item);
    _animatedList.insertItem(index);
  }

  E removeAt(int index) {
    final E removedItem = _items.removeAt(index);
    if (removedItem != null) {
      _animatedList.removeItem(
          index,
          (context, animation) =>
              removeItemBuilder(removedItem as Uint8List, context, animation));
    }
    return removedItem;
  }

  int get length => _items.length;

  E operator [](int index) => _items[index];

  int indexOf(E item) => _items.indexOf(item);
}
