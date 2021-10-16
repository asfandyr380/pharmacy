class ProductModel {
  int id = 0;
  String name = '';
  int quantity = 0;
  num? discount = 0;
  num? unit = 0;
  num? salePrice = 0;
  num amount = 0;
  String batchNo = '0';
  int? packs = 0;

  ProductModel({
    required this.amount,
    this.discount,
    this.unit,
    this.packs,
    this.salePrice,
    required this.id,
    required this.batchNo,
    required this.name,
    required this.quantity,
  });

  ProductModel.fromJson(Map map)
      : id = map['id'],
        name = map['name'],
        quantity = map['qty'],
        discount = map['disc'],
        unit = map['unit'],
        salePrice = map['salePrice'],
        amount = map['amt'],
        packs = map['packs'],
        batchNo = map['batch_no'];
}
