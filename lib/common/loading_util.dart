import 'package:flutter/material.dart';

class LoadingUtil<T> {
  ScrollController scrollController = ScrollController();

  int pageIndex = 0;
  bool hasMoreData = true;
  bool isLoading = false;
  bool isEmpty = false;
  bool hasError = false;
  List<T> list = [];

  LoadingUtil();

  void initListener(Function callback) {
    callback();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          hasMoreData) {
        callback();
      }
    });
  }

  void controllerDestroy() {
    scrollController.dispose();
  }

  void clear() {
    list.clear();
    hasMoreData = true;
    pageIndex = 0;
    isLoading = false;
    isEmpty = false;
  }
}
