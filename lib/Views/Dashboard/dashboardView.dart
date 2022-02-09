import 'package:flutter/material.dart';
import 'package:medical_store/Views/Dashboard/dashboardViewModel.dart';
import 'package:medical_store/Views/Widgets/CardBox/cardbox.dart';
import 'package:medical_store/Views/Widgets/LowStockBox/lowstockbox.dart';
import 'package:medical_store/Views/Widgets/PageIndicatorText/pageindicatorText.dart';
import 'package:stacked/stacked.dart';
import "package:velocity_x/velocity_x.dart";

class DashboardView extends StatelessWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DashboardViewModel>.reactive(
      viewModelBuilder: () => DashboardViewModel(),
      onModelReady: (model) => model.init(),
      disposeViewModel: false,
      builder: (ctx, model, child) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PageIndicationText(text: "Dashboard"),
            VxResponsive(
              medium: CardViewLarge(
                salesAmount: model.salesAmount,
                noofSales: model.salesCount,
                noofPurchase: model.purchaseCount,
                purchaseAmunt: model.purchaseAmount,
                totalMedicine: model.medicineCount,
                totalShelf: model.shelfCount,
                totalStock: model.stockCount,
                totalSupplier: model.supplierCount,
                profit: model.profit,
              ),
              xlarge: CardViewLarge(
                salesAmount: model.salesAmount,
                noofSales: model.salesCount,
                noofPurchase: model.purchaseCount,
                purchaseAmunt: model.purchaseAmount,
                totalMedicine: model.medicineCount,
                totalShelf: model.shelfCount,
                totalStock: model.stockCount,
                totalSupplier: model.supplierCount,
                profit: model.profit,
              ),
              large: CardViewLarge(
                salesAmount: model.salesAmount,
                noofSales: model.salesCount,
                noofPurchase: model.purchaseCount,
                purchaseAmunt: model.purchaseAmount,
                totalMedicine: model.medicineCount,
                totalShelf: model.shelfCount,
                totalStock: model.stockCount,
                totalSupplier: model.supplierCount,
                profit: model.profit,
              ),
              small: CardViewSmall(
                salesAmount: model.salesAmount,
                noofSales: model.salesCount,
                noofPurchase: model.purchaseCount,
                purchaseAmunt: model.purchaseAmount,
                totalMedicine: model.medicineCount,
                totalShelf: model.shelfCount,
                totalStock: model.stockCount,
                totalSupplier: model.supplierCount,
              ),
              xsmall: CardViewXsmall(
                salesAmount: model.salesAmount,
                noofSales: model.salesCount,
                noofPurchase: model.purchaseCount,
                purchaseAmunt: model.purchaseAmount,
                totalMedicine: model.medicineCount,
                totalShelf: model.shelfCount,
                totalStock: model.stockCount,
                totalSupplier: model.supplierCount,
              ),
              fallback: Text('No Layout Specified'),
            ),
            // Bottom Padding
            SizedBox(
              height: context.percentHeight * 5,
            ),
          ],
        ),
      ),
    );
  }
}

class CardViewXsmall extends StatelessWidget {
  final int totalShelf;
  final int totalMedicine;
  final int totalStock;
  final int totalSupplier;
  final int noofPurchase;
  final num purchaseAmunt;
  final int noofSales;
  final num salesAmount;
  const CardViewXsmall({
    required this.noofPurchase,
    required this.totalMedicine,
    required this.totalShelf,
    required this.totalStock,
    required this.totalSupplier,
    required this.noofSales,
    required this.salesAmount,
    required this.purchaseAmunt,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CardBox(
              widthPercent: 48,
              icon: Icons.format_list_bulleted,
              label: 'Total Shelf',
              noCount: totalShelf,
            ),
            CardBox(
              widthPercent: 48,
              icon: Icons.healing_outlined,
              label: 'Total Medicine',
              iconColor: Vx.red500,
              noCount: totalMedicine,
            ),
          ],
        ),
        SizedBox(
          height: context.percentHeight * 2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CardBox(
              widthPercent: 48,
              icon: Icons.shopping_bag,
              label: 'Total Stock Quantity',
              iconColor: Vx.red500,
              noCount: totalStock,
            ),
            CardBox(
              widthPercent: 48,
              icon: Icons.people_alt,
              label: 'Total Suppliers',
              noCount: totalSupplier,
            ),
          ],
        ),
        SizedBox(
          height: context.percentHeight * 2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CardBox(
              widthPercent: 48,
              icon: Icons.shopping_cart,
              label: 'No of Purchase',
              iconColor: Vx.green500,
              noCount: noofPurchase,
            ),
            CardBox(
              widthPercent: 48,
              icon: Icons.money,
              label: 'Total Purchase Amount',
              iconColor: Vx.green500,
              noCount: purchaseAmunt,
            ),
          ],
        ),
        SizedBox(
          height: context.percentHeight * 2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CardBox(
              widthPercent: 48,
              icon: Icons.shopping_basket,
              label: 'No of Sales',
              iconColor: Vx.green500,
              noCount: noofSales,
            ),
            CardBox(
              widthPercent: 48,
              icon: Icons.money,
              label: 'Total Sales Amount',
              iconColor: Vx.green500,
              noCount: salesAmount,
            ),
          ],
        ),
      ],
    );
  }
}

class CardViewSmall extends StatelessWidget {
  final int totalShelf;
  final int totalMedicine;
  final int totalStock;
  final int totalSupplier;
  final int noofPurchase;
  final num purchaseAmunt;
  final int noofSales;
  final num salesAmount;
  const CardViewSmall({
    required this.noofPurchase,
    required this.totalMedicine,
    required this.totalShelf,
    required this.totalStock,
    required this.totalSupplier,
    required this.noofSales,
    required this.salesAmount,
    required this.purchaseAmunt,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CardBox(
              widthPercent: 31,
              icon: Icons.format_list_bulleted,
              label: 'Total Shelf',
              noCount: totalShelf,
            ),
            CardBox(
              widthPercent: 31,
              icon: Icons.healing_outlined,
              label: 'Total Medicine',
              iconColor: Vx.red500,
              noCount: totalMedicine,
            ),
            CardBox(
              widthPercent: 31,
              icon: Icons.shopping_bag,
              label: 'Total Stock Quantity',
              iconColor: Vx.red500,
              noCount: totalStock,
            ),
          ],
        ),
        SizedBox(
          height: context.percentHeight * 2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CardBox(
              widthPercent: 31,
              icon: Icons.people_alt,
              label: 'Total Suppliers',
              noCount: totalSupplier,
            ),
            CardBox(
                widthPercent: 31,
                icon: Icons.shopping_cart,
                label: 'No of Purchase',
                iconColor: Vx.green500,
                noCount: noofPurchase),
            CardBox(
              widthPercent: 31,
              icon: Icons.money,
              label: 'Total Purchase Amount',
              iconColor: Vx.green500,
              noCount: purchaseAmunt,
            ),
          ],
        ),
        SizedBox(
          height: context.percentHeight * 2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CardBox(
              widthPercent: 31,
              icon: Icons.shopping_basket,
              label: 'No of Sales',
              iconColor: Vx.green500,
              noCount: noofSales,
            ),
            CardBox(
              widthPercent: 31,
              icon: Icons.money,
              label: 'Total Sales Amount',
              iconColor: Vx.green500,
              noCount: salesAmount,
            ),
          ],
        ),
        SizedBox(
          height: context.percentHeight * 8,
        ),
        LowStockBox(
          percentWidth: 98,
        )
      ],
    );
  }
}

class CardViewLarge extends StatelessWidget {
  final int totalShelf;
  final int totalMedicine;
  final int totalStock;
  final int totalSupplier;
  final int noofPurchase;
  final num purchaseAmunt;
  final int noofSales;
  final num salesAmount;
  final num profit;
  const CardViewLarge({
    required this.noofPurchase,
    required this.totalMedicine,
    required this.totalShelf,
    required this.totalStock,
    required this.totalSupplier,
    required this.noofSales,
    required this.salesAmount,
    required this.purchaseAmunt,
    required this.profit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CardBox(
              widthPercent: 18,
              icon: Icons.format_list_bulleted,
              label: 'Total Shelf',
              noCount: totalShelf,
            ),
            CardBox(
              widthPercent: 18,
              icon: Icons.healing_outlined,
              label: 'Total Medicine',
              iconColor: Vx.red500,
              noCount: totalMedicine,
            ),
            CardBox(
              widthPercent: 18,
              icon: Icons.shopping_bag,
              label: 'Total Stock Quantity',
              iconColor: Vx.red500,
              noCount: totalStock,
            ),
            CardBox(
              widthPercent: 18,
              icon: Icons.people_alt,
              label: 'Total Suppliers',
              noCount: totalSupplier,
            ),
          ],
        ),
        SizedBox(
          height: context.percentHeight * 2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CardBox(
              widthPercent: 18,
              icon: Icons.shopping_cart,
              label: 'No of Purchase',
              iconColor: Vx.green500,
              noCount: noofPurchase,
            ),
            CardBox(
              widthPercent: 18,
              icon: Icons.money,
              label: 'Total Purchase Amount',
              iconColor: Vx.green500,
              noCount: purchaseAmunt,
            ),
            CardBox(
              widthPercent: 18,
              icon: Icons.shopping_basket,
              label: 'No of Sales',
              iconColor: Vx.green500,
              noCount: noofSales,
            ),
            CardBox(
              widthPercent: 18,
              icon: Icons.money,
              label: 'Total Sales Amount',
              iconColor: Vx.green500,
              noCount: salesAmount,
            ),
          ],
        ),
        SizedBox(
          height: context.percentHeight * 2,
        ),
        CardBox(
              widthPercent: 18,
              icon: Icons.money,
              label: 'Total Profit',
              iconColor: Vx.green500,
              noCount: profit,
            ).pOnly(left: 20),
        SizedBox(
          height: context.percentHeight * 8,
        ),
        LowStockBox(
          percentWidth: 76.8,
        )
      ],
    );
  }
}
