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
    required this.paid,
    this.previous,
  });
  final int? id;
  final int? customerId;
  num total;
  num discount;
  num grandTotal;
  num tax;
  num paid;
  num? previous;
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
        paid = map['paid'],
        previous = map['previous'],
        note = map['note'];
}
