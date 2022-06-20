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
    name = "申请代理";
    id = value;
    switch (id) {
      case 1:
        name = "代理(启用)";
        break;
      case 2:
        name = "代理审核中";
        break;
      case 4:
        name = "代理(禁用)";
        break;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
