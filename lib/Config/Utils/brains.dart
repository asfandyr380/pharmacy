import 'package:medical_store/Models/product_model.dart';

class Brains {
  /// This Function is used to Sum the amount of all the Products and return a total of those amounts
  static double calculateProductTotalAmt(List<ProductModel> list) {
    double totalAmt = 0;
    for (var l in list) {
      totalAmt += l.amount;
    }
    return totalAmt;
  }

  /// This Function is use to calculate Grandtotal of all the products
  static double calculateGrandtotal(double totalAmt, double disc) {
    double grandtotal = 0;
    grandtotal = totalAmt - (totalAmt * disc / 100);
    return grandtotal;
  }
}
