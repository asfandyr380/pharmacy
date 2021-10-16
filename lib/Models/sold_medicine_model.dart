import 'package:flutter/material.dart';

class SoldMedicineModel {
  int? id = 0;
  int? saleId = 0;
  String medicineName = '';
  int quantity = 0;
  num unitPrice = 0;
  num salePrice = 0;
  String batchNo = '';
  num discount = 0;
  num totalAmt = 0;
  int packs = 0;

  SoldMedicineModel({
    required this.batchNo,
    required this.discount,
    this.id,
    required this.medicineName,
    required this.quantity,
    this.saleId,
    required this.salePrice,
    required this.totalAmt,
    required this.unitPrice,
    required this.packs,
  });

  SoldMedicineModel.fromJson(Map map)
      : id = map['id'],
        saleId = map['sale_Id'],
        medicineName = map['name'],
        quantity = map['qnt'],
        unitPrice = map['unt'],
        salePrice = map['salePrice'],
        batchNo = map['batch_no'].toString(),
        discount = map['disc'],
        packs = map['packs'],
        totalAmt = map['total'];

  SoldMedicineModel.clone(SoldMedicineModel source)
      : id = source.id,
        saleId = source.saleId,
        medicineName = source.medicineName,
        quantity = source.quantity,
        unitPrice = source.unitPrice,
        salePrice = source.salePrice,
        batchNo = source.batchNo,
        discount = source.discount,
        packs = source.packs,
        totalAmt = source.totalAmt;
}
