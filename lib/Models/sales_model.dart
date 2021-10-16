class SalesModel {
  SalesModel({
    this.id,
    this.customerId,
    required this.total,
    required this.discount,
    required this.grandTotal,
    required this.date,
    required this.note,
    required this.tax,
    required this.time,
  });
  final int? id;
  final int? customerId;
  num total;
  num discount;
  num grandTotal;
  num tax;
  final String date;
  final String note;
  final String time;
  num received = 0;

  SalesModel.fromJson(Map map)
      : id = map['id'],
        customerId = map['customer_Id'] ?? '',
        total = map['total'],
        discount = map['disc'],
        grandTotal = map['grandTotal'],
        date = map['date'],
        tax = map['tax'],
        time = map['time'],
        received = map['received'],
        note = map['note'];
}
