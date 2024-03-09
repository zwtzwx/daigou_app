import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class ListLoadingModel<T> {
  ScrollController scrollController = ScrollController();

  int pageIndex = 0;
  bool hasMoreData = true;
  bool isLoading = false;
  bool isEmpty = false;
  bool hasError = false;
  final position = 0.0.obs;
  List<T> list = [];

  ListLoadingModel();

  void initListener(
    Function callback, {
    bool recordPosition = false,
    Function(double value)? onPositionChange,
  }) {
    callback();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          hasMoreData) {
        callback();
      }
      if (recordPosition) {
        position.value = scrollController.position.pixels;
        if (onPositionChange != null) {
          onPositionChange(scrollController.position.pixels);
        }
      }
    });
  }

  void controllerDestroy() {
    scrollController.dispose();
  }

  void clear() {
    list.clear();
    position.value = 0;
    hasMoreData = true;
    pageIndex = 0;
    isLoading = false;
    isEmpty = false;
  }
}
