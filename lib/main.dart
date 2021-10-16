import 'package:flutter/material.dart';
import 'package:medical_store/Config/Utils/locator.dart';
import 'package:medical_store/Root/Root.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize LazySingletons
  setupLocator();
  runApp(Root());
}
