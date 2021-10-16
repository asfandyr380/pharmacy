import 'package:flutter/material.dart';
import 'package:medical_store/Config/Utils/inputValidation.dart';
import 'package:medical_store/Views/Login/loginViewModel.dart';
import 'package:medical_store/Views/Widgets/CustomButton/custombutton.dart';
import 'package:medical_store/Views/Widgets/TextInputField/textinptfield.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      builder: (ctx, model, child) => Scaffold(
        body: Form(
          key: model.formKey,
          autovalidateMode: model.mode,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFieldWithLable(
                hint: 'Enter your email',
                lable: 'Email',
                validateForm: (_) => InputValidation.emailValidation(_),
                controller: model.emailController,
                onSubmit: (_) {},
              ),
              SizedBox(height: 20),
              TextFieldWithLable(
                hint: 'Enter Password',
                lable: 'Password',
                validateForm: (_) => InputValidation.emptyFieldValidation(_),
                controller: model.passwordController,
                onSubmit: (_) {},
              ),
              SizedBox(height: 10),
              CustomButtonLarge(
                onPress: () => model.login(context),
                text: "Login",
                isLoading: model.isLoading,
              )
            ],
          ).px(context.percentWidth * 30),
        ),
      ),
    );
  }
}
