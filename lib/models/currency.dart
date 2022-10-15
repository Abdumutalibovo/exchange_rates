class currencyModel {
  String title;
  String code;
  String cb_price;
  String buy;
  String cell;
  String data;

  currencyModel({
    required this.title,
    required this.code,
    required this.cb_price,
    required this.buy,
    required this.cell,
    required this.data,
  });

  factory currencyModel.fromJson(Map<String, dynamic> jsonData) {
    String title = jsonData['title'] ?? "";
    String code = jsonData['code'] ?? "";
    String cb_price = jsonData['cb_price'] ?? "";
    String buy = jsonData['nbu_buy_price'] ?? "";
    String cell = jsonData['nbu_cell_price'] ?? "";
    String data = jsonData['data'] ?? "";

    return currencyModel(
      title: title,
      code: code,
      cb_price: cb_price,
      buy: buy,
      cell: cell,
      data: data,
    );
  }
}
