/*
  评价Model
 */
import 'package:jiyun_app_client/models/order_model.dart';
import 'package:jiyun_app_client/models/receiver_address_model.dart';
import 'package:jiyun_app_client/models/user_model.dart';

class CommentModel {
  late int id;
  late int isRecommend;
  late String content;
  late List<String> images;
  late int score;
  late int logisticsScore;
  late int customerScore;
  late int packScore;
  late String createdAt;
  UserModel? user;
  OrderModel? order;

  CommentModel();

  CommentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isRecommend = json['is_recommend'];
    content = json['content'];
    images = json['images'].cast<String>();
    score = json['score'];
    logisticsScore = json['logistics_score'];
    customerScore = json['customer_score'];
    packScore = json['pack_score'];
    createdAt = json['created_at'];

    if (json['user'] != null) {
      //这里只有两个
      user = UserModel.empty();
      user!.avatar = json['user']['avatar'];
      user!.id = json['user']['id'];
      user!.name = json['user']['name'];
    }
    if (json['order'] != null) {
      order = OrderModel();
      order!.orderSn = json['order']['order_sn'];

      order!.address = ReceiverAddressModel();
      order!.address.countryName = json['order']['address']['country_name'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['is_recommend'] = isRecommend;
    data['content'] = content;
    data['images'] = images;
    data['score'] = score;
    data['logistics_score'] = logisticsScore;
    data['customer_score'] = customerScore;
    data['pack_score'] = packScore;
    // data['user_id'] = userId;
    // data['order_id'] = orderId;
    // data['company_id'] = companyId;
    data['created_at'] = createdAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (order != null) {
      data['order'] = order!.toJson();
    }
    return data;
  }
}
