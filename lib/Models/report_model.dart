class ReportModel {
  int? report_Id = 0;
  int customer_Id = 0;
  num debit = 0;
  num credit = 0;
  num balance = 0;
  String date = "";
  num previous_balance = 0;

  ReportModel({
    required this.customer_Id,
    required this.balance,
    required this.credit,
    required this.date,
    required this.debit,
    this.report_Id,
  });

  ReportModel.fromJson(Map json)
      : report_Id = json['report_Id'],
        customer_Id = json['cus_Id'],
        debit = json['debit'],
        credit = json['credit'],
        balance = json['balance'],
        previous_balance = json['previous'],
        date = json['date'];
}
