import 'package:flutter/material.dart';
import 'package:medical_store/Services/Local_Storage/local_storage.dart';
import 'package:medical_store/Views/LandingPage/landingView.dart';
import 'package:medical_store/Views/Login/loginView.dart';

class Root extends StatefulWidget {
  const Root({Key? key}) : super(key: key);

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  bool authState = false;

  @override
  void initState() {
    super.initState();
    LocalStorage.checkUser().then((state) {
      setState(() {
        authState = state;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: authState ? LandingPage() : LoginView(),
    );
  }
}
