import 'package:get/get.dart';
import 'package:huanting_shop/config/base_conctroller.dart';
import 'package:huanting_shop/models/comment_model.dart';
import 'package:huanting_shop/services/comment_service.dart';

class TransportCenterController extends GlobalLogic {
  final commentList = <CommentModel>[].obs;

  @override
  onInit() {
    super.onInit();
    getComments();
  }

  Future<void> handleRefresh() async {
    await getComments();
  }

  getComments() async {
    var res = await CommentService.getList();
    if (res['dataList'] != null) {
      commentList.value = res['dataList'];
    }
  }
}
