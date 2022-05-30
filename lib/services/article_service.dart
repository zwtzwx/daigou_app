import 'package:jiyun_app_client/common/http_client.dart';
import 'package:jiyun_app_client/models/article_model.dart';
import 'package:jiyun_app_client/services/base_service.dart';

class ArticleService {
  // 列表
  static const String listApi = 'order-notice';
  // 投诉建议
  static const String suggestionApi = 'suggestion';

  /// 获取文章列表
  /// params: type = 1 常见问题; type = 2 禁运物品; type = 3 下单须知; type = 5 关于我们
  static Future<Map?> getList([Map<String, dynamic>? params]) async {
    var page = params?['page'] ?? 1;
    params!["page"] = page;
    List<ArticleModel> dataList = <ArticleModel>[];
    Map result = {"dataList": null, 'total': 1, 'pageIndex': page};

    await HttpClient().get(listApi, queryParameters: params).then((response) {
      var list = response.data;

      list.forEach((item) {
        dataList.add(ArticleModel.fromJson(item));
      });
      result = {"dataList": dataList, 'total': 1, 'pageIndex': 1};
    });
    return result;
  }

  // 投诉建议
  static void onSuggestion(
      Map<String, dynamic> params, OnSuccess onSuccess, OnFail onFail) async {
    await HttpClient().post(suggestionApi, queryParameters: params).then((res) {
      if (res.ok) {
        onSuccess(res.msg);
      } else {
        onFail(res.msg.toString());
      }
    }).onError((error, stackTrace) => onFail(error.toString()));
  }
}
