/*
  评价
 */
import 'package:huanting_shop/common/http_client.dart';
import 'package:huanting_shop/models/comment_model.dart';

class CommentService {
  // 评论列表
  static const String dataListApi = 'order-comment';
  // 评论详情
  static const String dataOneApi = 'order-comment/:id';
  // 评价提示
  static const String commentInfoApi = 'order-comment/illustrate';
  // 提交评价
  static const String commentApi = 'order-comment';

  /*
    评价列表
   */
  static Future<Map> getList([Map<String, dynamic>? params]) async {
    var page = (params is Map) ? params!['page'] : 1;

    Map result = {"dataList": null, 'total': 1, 'pageIndex': page};

    List<CommentModel> dataList = <CommentModel>[];

    await BeeRequest.instance
        .get(dataListApi, queryParameters: params)
        .then((response) {
      var list = response.data;
      list['data']?.forEach((item) {
        dataList.add(CommentModel.fromJson(item));
      });
      result = {
        "dataList": dataList,
        'total': response.data['last_page'],
        'pageIndex': response.data['current_page']
      };
    });

    return result;
  }

  /*
    评价说明
  */
  static Future<String> getInfo() async {
    String tips = '';
    await BeeRequest.instance.get(commentInfoApi).then((res) {
      tips = res.data['illustrate'] ?? '';
    });
    return tips;
  }

  /*
    提交评价
   */
  static Future<Map> onComment(Map<String, dynamic> params) async {
    Map result = {'ok': false, 'msg': null};
    await BeeRequest.instance.post(commentApi, data: params).then((res) => {
          result = {'ok': res.ok, 'msg': res.msg ?? res.error!.message}
        });
    return result;
  }

  /*
    评价详情
   */
  static Future<CommentModel?> getDetail(int id) async {
    CommentModel? result;
    await BeeRequest.instance
        .get(dataOneApi.replaceAll(':id', id.toString()))
        .then((res) {
      if (res.ok) {
        result = CommentModel.fromJson(res.data[0]);
      }
    });
    return result;
  }
}
