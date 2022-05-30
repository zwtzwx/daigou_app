/*
  联系人信息
 */
class ContactModel {
  late String name;
  late String phone;

  ContactModel({required this.name, required this.phone});

  ContactModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['phone'] = phone;
    return data;
  }
}
