// ignore_for_file: constant_identifier_names

import 'package:jiyun_app_client/common/http_client.dart';
import 'package:jiyun_app_client/models/announcement_model.dart';

class AnnouncementService {
  // 列表
  static const String LISTAPI = 'announcement';
  // 首页最新公告
  static const String latestApi = 'announcement/index-announcement';
  // 详情
  static const String detailApi = 'announcement/:id';

  // 获列表
  static Future<Map> getList([Map<String, dynamic>? params]) async {
    var page = (params is Map) ? params!['page'] : 1;
    Map result = {"dataList": null, 'total': 1, 'pageIndex': page};
    List<AnnouncementModel> dataList = [];
    await HttpClient().get(LISTAPI, queryParameters: params).then((response) {
      var list = response.data;
      list['data']?.forEach((item) {
        dataList.add(AnnouncementModel.fromJson(item));
      });
      result = {
        "dataList": dataList,
        'total': response.data['last_page'],
        'pageIndex': response.data['current_page']
      };
    });
    return result;
  }

  // 首页最新公告
  static Future<AnnouncementModel?> getLatest() async {
    AnnouncementModel? result;
    await HttpClient().get(latestApi).then((res) => {
          if (res.data != null) {result = AnnouncementModel.fromJson(res.data)}
        });
    return result;
  }

  // 公告详情
  static Future<AnnouncementModel?> getDetail(int id) async {
    AnnouncementModel? result;
    await HttpClient()
        .get(detailApi.replaceAll(':id', id.toString()))
        .then((res) => {
              if (res.data != null)
                {result = AnnouncementModel.fromJson(res.data)}
            });
    return result;
  }
}
