import 'package:huanting_shop/config/base_conctroller.dart';
import 'package:huanting_shop/services/comment_service.dart';

class CommentController extends GlobalLogic {
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
