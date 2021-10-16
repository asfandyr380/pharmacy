import 'package:get_it/get_it.dart';
import 'package:medical_store/Config/Db_Config.dart';
import 'package:medical_store/Services/Auth_Services/Login/login.dart';
import 'package:medical_store/Services/Auth_Services/User/user.dart';
import 'package:medical_store/Services/DB_Services/Category/category.dart';
import 'package:medical_store/Services/DB_Services/Customers/cutomers.dart';
import 'package:medical_store/Services/DB_Services/Employee/employee.dart';
import 'package:medical_store/Services/DB_Services/Medicine/medicine.dart';
import 'package:medical_store/Services/DB_Services/Purchase/purchase.dart';
import 'package:medical_store/Services/DB_Services/Sales/sales.dart';
import 'package:medical_store/Services/DB_Services/Shelf/shelf.dart';
import 'package:medical_store/Services/DB_Services/Stock/stock.dart';
import 'package:medical_store/Services/DB_Services/Supplier/supplier.dart';
import 'package:medical_store/Views/Widgets/PaginatedDataTable/dataSource.dart';

final GetIt locator = GetIt.instance;

setupLocator() {
  locator.registerLazySingleton(() => DataSource());
  locator.registerLazySingleton(() => SalesService());
  locator.registerLazySingleton(() => DataBaseConnection());
  locator.registerLazySingleton(() => ShelfService());
  locator.registerLazySingleton(() => CategoryService());
  locator.registerLazySingleton(() => MedicineService());
  locator.registerLazySingleton(() => StockService());
  locator.registerLazySingleton(() => CustomersService());
  locator.registerLazySingleton(() => SupplierService());
  locator.registerLazySingleton(() => EmployeeService());
  locator.registerLazySingleton(() => PurchaseService());
  locator.registerLazySingleton(() => LoginService());
  locator.registerLazySingleton(() => UserService());
}
