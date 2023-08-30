class CurrencyRateModel {
  late String code;
  late String symbol;
  late num rate;

  CurrencyRateModel({required this.code, required this.symbol, this.rate = 1});

  CurrencyRateModel.from(Map<String, dynamic> json) {
    code = json['currency_code'];
    symbol = json['symbol'];
    rate = num.parse(json['rate'] ?? '1');
  }
}
