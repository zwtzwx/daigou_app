import 'package:get/get.dart';
import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:jiyun_app_client/services/comment_service.dart';

class CommentController extends BaseController {
  int pageIndex = 0;

  loadList({type}) async {
    pageIndex = 0;
    return await loadMoreList();
  }

  loadMoreList() async {
    Map dic = await CommentService.getList({
      'page': (++pageIndex),
      'size': '10',
    });
    return dic;
  }

  /// dispose 释放内存
  @override
  void dispose() {
    super.dispose();
  }
}
