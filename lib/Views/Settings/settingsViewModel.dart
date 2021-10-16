import 'package:flutter/material.dart';
import 'package:medical_store/Config/Utils/locator.dart';
import 'package:medical_store/Models/user_setting_model.dart';
import 'package:medical_store/Models/users_model.dart';
import 'package:medical_store/Services/Auth_Services/Login/login.dart';
import 'package:medical_store/Services/Local_Storage/local_storage.dart';
import 'package:medical_store/Views/LandingPage/landingViewModel.dart';

class SettingsViewModel extends ChangeNotifier {
  init() {
    getUserInfo();
    getUserSetting();
  }

  LoginService _loginService = locator<LoginService>();

  TextEditingController nameController = TextEditingController();
  TextEditingController currencyController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController webController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController pNoteController =
      TextEditingController(); // Purchase Note
  TextEditingController sNoteController = TextEditingController(); // Sales Note
  TextEditingController addressController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode mode = AutovalidateMode.disabled;
  bool isLoading = false;
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
    nameController.dispose();
    currencyController.dispose();
    emailController.dispose();
    webController.dispose();
    phoneController.dispose();
    pNoteController.dispose();
    sNoteController.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  // Dispose Stuff
  int userId = 0;
  getUserInfo() async {
    var user = await LocalStorage.getUserInfo();
    nameController.text = user!.shopename!;
    emailController.text = user.email!;
    phoneController.text = user.phone.toString();
    userId = user.id!;
    addressController.text = user.address1 ?? '';
    notifyListeners();
  }

  int settingId = 0;
  getUserSetting() async {
    var setting = await LocalStorage.getUserSetting();
    currencyController.text = setting!.currency;
    webController.text = setting.web;
    pNoteController.text = setting.pNote;
    sNoteController.text = setting.sNote;
    settingId = setting.id;
    notifyListeners();
  }

  setBusy(bool state) {
    isLoading = state;
    notifyListeners();
  }

  update() async {
    if (connection) {
      if (validateInput() == 1) {
        setBusy(true);
        UserModel _userModel = UserModel(
          email: emailController.text,
          id: userId,
          shopename: nameController.text,
          phone: int.parse(phoneController.text),
          address1: addressController.text,
        );

        UserSetting _userSetting = UserSetting(
          currencyController.text,
          settingId,
          pNoteController.text,
          sNoteController.text,
          webController.text,
        );
        await _loginService
            .updateUserSetting(_userSetting, _userModel)
            .then((value) {
          init();
        });
        setBusy(false);
      }
    }
  }
}
