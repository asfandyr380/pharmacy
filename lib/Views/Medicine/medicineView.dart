import 'package:flutter/material.dart';
import 'package:medical_store/Models/medicine_model.dart';
import 'package:medical_store/Views/Medicine/medicineViewModel.dart';
import 'package:medical_store/Views/Widgets/CustomButton/custombutton.dart';
import 'package:medical_store/Views/Widgets/CustomTableHeader/customtableheader.dart';
import 'package:medical_store/Views/Widgets/ListingBox/listingbox.dart';
import 'package:medical_store/Views/Widgets/ListingBox/paginationButtons.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class MedicineView extends StatelessWidget {
  final Function? newMedicie;
  final Function? edit;

  MedicineView({this.newMedicie, this.edit});

  _showDeleteDialog(BuildContext context, {required Function onConfirm}) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Delete"),
        content: TextFormField(
          decoration: InputDecoration(hintText: "Confirmation Password"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(_),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              onConfirm();
              Navigator.pop(_);
            },
            child: Text("Confirm"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MedicineViewModel>.reactive(
      viewModelBuilder: () => MedicineViewModel(),
      onModelReady: (model) => model.init(),
      builder: (ctx, model, child) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NewButton(
              text: 'New Medicine',
              onPress: () => newMedicie!(),
            ),
            SizedBox(height: context.percentHeight * 3),
            ListingBox(
              boxContent: ListingBoxContent(
                onSubmit: (_) {},
                onChange: (val) => model.searchMedicine(val),
                contentWidget: MedicinTableContent(
                  medicinelist: model.medicinelist,
                  onRemove: (m) => _showDeleteDialog(context, onConfirm: () => model.remove(m)),
                  pageNo: model.pageNo,
                  onNext: () => model.nextPage(),
                  onPrevious: () => model.previous(),
                  isLastPage: model.lastPage,
                  onEdit: (m) => edit!(m),
                ),
                headerTxt: 'Medicine List',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MedicinTableContent extends StatelessWidget {
  final List<MedicineModel> medicinelist;
  final Function? onRemove;
  final int pageNo;
  final Function? onNext;
  final Function? onPrevious;
  final bool? isLastPage;
  final Function? onEdit;

  const MedicinTableContent({
    required this.medicinelist,
    this.onRemove,
    required this.pageNo,
    this.onNext,
    this.onPrevious,
    this.isLastPage,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableHeader2(
            headerLables: ['Name', 'Category', 'Formula', 'Company', 'Action']),
        for (var medicine in medicinelist)
          MedicinTableItems(
            medicine: medicine,
            onRemove: (_) => onRemove!(_),
            onEdit: (_) => onEdit!(_),
          ),
        SizedBox(
          height: context.percentHeight * 3,
        ),
        PaginationButtons(
          pageNO: pageNo,
          onNext: () => onNext!(),
          onPrevious: () => onPrevious!(),
          lastPage: isLastPage,
        )
      ],
    );
  }
}

class MedicinTableItems extends StatelessWidget {
  final MedicineModel medicine;
  final Function? onRemove;
  final Function? onEdit;
  const MedicinTableItems({required this.medicine, this.onRemove, this.onEdit});
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MedicineViewModel>.reactive(
      viewModelBuilder: () => MedicineViewModel(),
      builder: (context, model, child) => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TableItem(itemName: medicine.medicineName),
              TableItem(itemName: medicine.category),
              TableItem(itemName: medicine.generic),
              TableItem(itemName: medicine.company),
              ActionButtons(
                  onAddorRemove: () => onRemove!(medicine),
                  onEdit: () => onEdit!(medicine)),
            ],
          ),
          Divider()
        ],
      ),
    );
  }
}
