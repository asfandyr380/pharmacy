class MedicineModel {
  MedicineModel(
    this.id,
    this.medicineName,
    this.batchNo,
    this.totalQuantity,
    this.sellingPrice,
    this.buyingPrice,
    this.category,
  );

  int id = 0;
  String medicineName = '';
  String batchNo = '';
  int totalQuantity = 0;
  num sellingPrice = 0;
  String category = '';
  num buyingPrice = 0;
  String generic = '';
  String company = '';

  MedicineModel.fromJson1(Map map)
      : id = map['id'],
        medicineName = map['name'],
        category = map['category'],
        generic = map['generic'],
        company = map['company'];

  MedicineModel.fromJson(Map map)
      : id = map['id'],
        medicineName = map['name'],
        batchNo = map['batchNo'] ?? '0',
        category = map['category'],
        generic = map['generic'],
        company = map['company'],
        totalQuantity = map['quantity'] ?? 0,
        sellingPrice = map['sellingPrice'] ?? 0,
        buyingPrice = map['buyingPrice'] ?? 0;
}
