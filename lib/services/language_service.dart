import 'package:dio/dio.dart';
import 'package:huanting_shop/common/http_client.dart';
import 'package:huanting_shop/models/language_model.dart';

class LanguageService {
  // 支持的语言列表
  static const String languageApi = 'languages';
  // 翻译内容
  static const String transformApi = 'language-tran';

  /*
    获取支持的语言列表
   */
  static Future<List<LanguageModel>> getLanguage() async {
    List<LanguageModel> dataList = [];
    await BeeRequest.instance.get(languageApi).then((res) {
      if (res.ok) {
        for (var item in res.data) {
          dataList.add(LanguageModel.fromJson(item));
        }
      }
    });
    return dataList;
  }

  /*
    获取对应语言的翻译内容
   */
  static Future<Map<String, dynamic>?> getTransform(Map<String, dynamic> params,
      [Options? option]) async {
    Map<String, dynamic>? result;
    await BeeRequest.instance
        .get(
      transformApi,
      queryParameters: params,
      options: option,
    )
        .then((res) {
      if (res.ok) {
        result = res.data;
      }
    });
    return result;
  }
}
