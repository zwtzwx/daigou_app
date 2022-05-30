/*
  物流查询
 */
class TrackingModel {
  late String context;
  late String ftime;

  TrackingModel();

  TrackingModel.fromJson(Map<String, dynamic> json) {
    context = json['context'];
    ftime = json['ftime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['context'] = context;
    data['ftime'] = ftime;
    return data;
  }
}
