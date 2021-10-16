class PurchaseModel {
  PurchaseModel({
    this.purchaseCode,
    required this.grandTotal,
    required this.total,
    required this.date,
    required this.note,
  });

  int? purchaseCode;
  num grandTotal;
  num total;
  String date;
  String note;

  PurchaseModel.fromJson(Map map)
      : purchaseCode = map['id'],
        grandTotal = map['grandTotal'],
        total = map['total'],
        date = map['date'],
        note = map['note'];
}
