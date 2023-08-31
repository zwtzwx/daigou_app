import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';
import 'widgets/widgets.dart';

class SuggestPage extends GetView<SuggestController> {
  const SuggestPage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return const HelloWidget();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SuggestController>(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("suggest")),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
