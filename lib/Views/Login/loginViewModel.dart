import 'package:flutter/material.dart';
import 'package:medical_store/Config/Utils/locator.dart';
import 'package:medical_store/Services/Auth_Services/Login/login.dart';
import 'package:medical_store/Views/LandingPage/landingView.dart';

class LoginViewModel extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode mode = AutovalidateMode.disabled;
  LoginService _loginService = locator<LoginService>();
  bool isLoading = false;

  setBusy(bool state) {
    isLoading = state;
    notifyListeners();
  }

  validateInput() {
    var formState = formKey.currentState;
    if (formState!.validate()) {
      return 1;
    } else {
      mode = AutovalidateMode.onUserInteraction;
      notifyListeners();
    }
  }

  bool _disposed = false;
  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }
  // Dispose Stuff

  login(BuildContext ctx) async {
    if (validateInput() == 1) {
      setBusy(true);
      var result = await _loginService.loginUser(
          emailController.text, passwordController.text);
      if (result != null) {
        Navigator.pushReplacement(
            ctx, MaterialPageRoute(builder: (ctx) => LandingPage()));
      }
      setBusy(false);
    }
  }
}
