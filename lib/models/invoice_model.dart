/*
  发票模型
 */
class InvoiceModel {
  late int id;
  late int userId;
  late int type;
  late int invoiceType;
  late String title;
  late String dutyParagraph;
  late String bankName;
  late String bankAccount;
  late String companyAddress;
  late String companyTel;
  late String createdAt;
  late String updatedAt;

  InvoiceModel();

  InvoiceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    type = json['type'];
    invoiceType = json['invoice_type'];
    title = json['title'];
    dutyParagraph = json['duty_paragraph'];
    bankName = json['bank_name'];
    bankAccount = json['bank_account'];
    companyAddress = json['company_address'];
    companyTel = json['company_tel'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['type'] = type;
    data['invoice_type'] = invoiceType;
    data['title'] = title;
    data['duty_paragraph'] = dutyParagraph;
    data['bank_name'] = bankName;
    data['bank_account'] = bankAccount;
    data['company_address'] = companyAddress;
    data['company_tel'] = companyTel;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
