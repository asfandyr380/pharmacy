import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medical_store/Config/routes.dart';
import 'package:medical_store/Models/medicine_model.dart';
import 'package:medical_store/Models/users_model.dart';
import 'package:medical_store/Services/Local_Storage/local_storage.dart';
import 'package:medical_store/Views/Category/categoryView.dart';
import 'package:medical_store/Views/Customers/NewCustomer/newCustomer.dart';
import 'package:medical_store/Views/Customers/customersView.dart';
import 'package:medical_store/Views/Dashboard/dashboardView.dart';
import 'package:medical_store/Views/Employes/NewEmploye/newEmploye.dart';
import 'package:medical_store/Views/Employes/employesView.dart';
import 'package:medical_store/Views/Login/loginView.dart';
import 'package:medical_store/Views/Medicine/New_Medicine/new_medicine.dart';
import 'package:medical_store/Views/Medicine/medicineView.dart';
import 'package:medical_store/Views/Purchase/purchaseView.dart';
import 'package:medical_store/Views/Reports/reports.dart';
import 'package:medical_store/Views/Sales/NewSales/newSales.dart';
import 'package:medical_store/Views/Sales/salesView.dart';
import 'package:medical_store/Views/Settings/settingsView.dart';
import 'package:medical_store/Views/Shelf/shelfView.dart';
import 'package:medical_store/Views/Stock/stockView.dart';
import 'package:medical_store/Views/Supplier/NewSupplier/newsupplier.dart';
import 'package:medical_store/Views/Supplier/supplierView.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

bool connection = false;

class LandingPageViewModel extends ChangeNotifier {
  Widget content = DashboardView();
  StreamSubscription? subscription;
  bool firstboot = true;
  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  init(BuildContext context) {
    SimpleConnectionChecker _simpleConnectionChecker =
        SimpleConnectionChecker();
    subscription =
        _simpleConnectionChecker.onConnectionChange.listen((connected) {
      connection = connected;
      notifyListeners();
      if (firstboot) {
        showMessageFirstBoot(context, connected);
        firstboot = false;
        notifyListeners();
      } else {
        showMessage(context, connected);
      }
    });
    getUser();
  }

  showMessageFirstBoot(BuildContext context, bool isConnected) {
    if (!isConnected) {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: "You are not Connected to the Internet",
        ),
        displayDuration: Duration(seconds: 10),
      );
    }
  }

  showMessage(BuildContext context, bool isConnected) {
    if (!isConnected) {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: "You are not Connected to the Internet",
        ),
        displayDuration: Duration(seconds: 10),
      );
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.success(
          message: "Internet Connection is Back",
        ),
      );
    }
  }

  newMedicine() {
    content = NewMedicineView();
    notifyListeners();
  }

  newCustomer() {
    content = NewCustomer();
    notifyListeners();
  }

  newSupplier() {
    content = NewSupplierView();
    notifyListeners();
  }

  newEmploye() {
    content = NewEmployeView();
    notifyListeners();
  }

  newPurchase() {
    // content = NewPurchaseView();
    notifyListeners();
    setVisible(true);
  }

  newSale() {
    // content = NewSalesView();
    notifyListeners();
    setVisible1(true);
  }

  editMedicine(MedicineModel m) {
    content = NewMedicineView(
      medicine: m,
    );
    notifyListeners();
  }

  editCustomer(UserModel m) {
    content = NewCustomer(
      customer: m,
    );
    notifyListeners();
  }

  editSupplier(UserModel m) {
    content = NewSupplierView(
      supplier: m,
    );
    notifyListeners();
  }

  editEmployee(UserModel m) {
    content = NewEmployeView(
      employee: m,
    );
    notifyListeners();
  }

  bool isVisible = false;
  bool isVisible1 = false;

  setVisible1(bool state) {
    isVisible1 = state;
    notifyListeners();
  }

  setVisible(bool state) {
    isVisible = state;
    notifyListeners();
  }

  List drawerItems = [
    {
      "label": Dashboard,
      "icon": FontAwesomeIcons.tachometerAlt,
      "isActive": true,
      "content": DashboardView()
    },
    {
      "label": Shelf,
      "icon": FontAwesomeIcons.bars,
      "isActive": false,
      "content": ShelfView()
    },
    {
      "label": Category,
      "icon": FontAwesomeIcons.tags,
      "isActive": false,
      "content": CategoryView()
    },
    {
      "label": Medicine,
      "icon": FontAwesomeIcons.firstAid,
      "isActive": false,
      "content": MedicineView(),
    },
    {
      "label": Customers,
      "icon": FontAwesomeIcons.users,
      "isActive": false,
      "content": CustomerView()
    },
    {
      "label": Supplier,
      "icon": FontAwesomeIcons.users,
      "isActive": false,
      "content": SupplierView()
    },
    {
      "label": Employes,
      "icon": FontAwesomeIcons.users,
      "isActive": false,
      "content": EmployesView()
    },
    {
      "label": Purchase,
      "icon": FontAwesomeIcons.shoppingCart,
      "isActive": false,
      "content": PurchaseView()
    },
    {
      "label": Stock,
      "icon": FontAwesomeIcons.shoppingBag,
      "isActive": false,
      "content": StockView()
    },
    {
      "label": Sales,
      "icon": FontAwesomeIcons.cashRegister,
      "isActive": false,
      "content": SalesView()
    },
    {
      "label": Settings,
      "icon": FontAwesomeIcons.userCog,
      "isActive": false,
      "content": SettingsView()
    },
    {
      "label": Reports,
      "icon": FontAwesomeIcons.info,
      "isActive": false,
      "content": ReportsView()
    },
  ];

  List drawerItemsEmployee = [
    {
      "label": Dashboard,
      "icon": FontAwesomeIcons.tachometerAlt,
      "isActive": true,
      "content": DashboardView()
    },
    {
      "label": Stock,
      "icon": FontAwesomeIcons.shoppingBag,
      "isActive": false,
      "content": StockView()
    },
    {
      "label": Sales,
      "icon": FontAwesomeIcons.cashRegister,
      "isActive": false,
      "content": SalesView()
    },
    {
      "label": Settings,
      "icon": FontAwesomeIcons.userCog,
      "isActive": false,
      "content": SettingsView()
    },
  ];

  navigate(String page, Widget content, var item) {
    setVisible(false);
    setVisible1(false);

    if (role == 'Admin') {
      drawerItems.forEach((e) {
        if (e != item) {
          e['isActive'] = false;
          notifyListeners();
        } else {
          e['isActive'] = true;
          notifyListeners();
        }
      });
    } else {
      drawerItemsEmployee.forEach((e) {
        if (e != item) {
          e['isActive'] = false;
          notifyListeners();
        } else {
          e['isActive'] = true;
          notifyListeners();
        }
      });
    }
    switch (page) {
      case Dashboard:
        this.content = content;
        notifyListeners();
        break;
      case Shelf:
        this.content = content;
        notifyListeners();
        break;
      case Category:
        this.content = content;
        notifyListeners();
        break;
      case Medicine:
        this.content = MedicineView(
          newMedicie: () => newMedicine(),
          edit: (m) => editMedicine(m),
        );
        notifyListeners();
        break;
      case Customers:
        this.content = CustomerView(
          newCustomer: () => newCustomer(),
          editCustomer: (m) => editCustomer(m),
        );
        notifyListeners();
        break;
      case Supplier:
        this.content = SupplierView(
          newSupplier: () => newSupplier(),
          editSupplier: (m) => editSupplier(m),
        );
        notifyListeners();
        break;
      case Employes:
        this.content = EmployesView(
          newEmploye: () => newEmploye(),
          editEmployee: (m) => editEmployee(m),
        );
        notifyListeners();
        break;
      case Purchase:
        this.content = PurchaseView(
          newPurchase: () => newPurchase(),
        );
        notifyListeners();
        break;
      case Stock:
        this.content = content;
        notifyListeners();
        break;
      case Sales:
        this.content = SalesView(
          newSale: () => newSale(),
        );
        notifyListeners();
        break;
      case Settings:
        this.content = content;
        notifyListeners();
        break;
      case Reports:
        this.content = content;
        notifyListeners();
        break;
    }
  }

  signOut(BuildContext ctx) async {
    LocalStorage.removeUserInfo().then((value) {
      if (value) {
        Navigator.pushReplacement(
            ctx, MaterialPageRoute(builder: (ctx) => LoginView()));
      }
    });
  }

  String name = 'ADMIN';
  String role = '';
  getUser() async {
    var result = await LocalStorage.getUserInfo();
    if (result != null) {
      name = result.name!;
      role = result.role!;
      notifyListeners();
    }
  }
}
