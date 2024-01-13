import 'package:get/get.dart';
import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:jiyun_app_client/models/comment_model.dart';
import 'package:jiyun_app_client/services/comment_service.dart';

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
