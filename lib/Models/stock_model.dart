class StockModel {
  StockModel(
    this.id,
    this.name,
    this.batchNo,
    this.totalQuantity,
    this.sellingPrice,
    this.buyingPrice,
  );

  final int id;
  final String name;
  final String batchNo;
  final int totalQuantity;
  final num sellingPrice;
  final num buyingPrice;

  StockModel.fromJson(Map map)
      : id = map['id'],
        name = map['name'],
        batchNo = map['batchNo'],
        totalQuantity = map['quantity'],
        sellingPrice = map['sellingPrice'],
        buyingPrice = map['buyingPrice'];
}
