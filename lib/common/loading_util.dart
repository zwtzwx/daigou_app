import 'package:flutter/material.dart';

class LoadingUtil<T> {
  ScrollController scrollController = ScrollController();

  int pageIndex = 0;
  bool hasMoreData = true;
  bool isLoading = false;
  bool isEmpty = false;
  bool hasError = false;
  double position = 0;
  List<T> list = [];

  LoadingUtil();

  void initListener(
    Function callback, {
    bool recordPosition = false,
  }) {
    callback();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          hasMoreData) {
        callback();
      }
      if (recordPosition) {
        position = scrollController.position.pixels;
      }
    });
  }

  void controllerDestroy() {
    scrollController.dispose();
  }

  void clear() {
    list.clear();
    position = 0;
    hasMoreData = true;
    pageIndex = 0;
    isLoading = false;
    isEmpty = false;
  }
}
