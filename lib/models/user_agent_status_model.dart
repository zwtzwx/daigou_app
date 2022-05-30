/*
 * 代理状态
 */

class UserAgentStatusModel {
  //id
  late num id;
  //状态
  late String name;

  UserAgentStatusModel({required this.id, required this.name});

  UserAgentStatusModel.fromId(num value) {
    name = "身份: 未申请";
    id = value;
    switch (id) {
      case 1:
        name = "身份：代理";
        break;
      case 2:
        name = "身份：审核中";
        break;
      case 3:
        name = "代理：代理身份禁用";
        break;
      default:
        name = "身份: 未申请";
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
