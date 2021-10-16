class InputValidation {
  static emptyFieldValidation(String val) {
    if (val.isEmpty) {
      return "Please Enter Somthing";
    }
  }

  static emptyDropdownValidation(String? val) {
    if (val == null) {
      return "Please Select Somthing";
    }
  }

  static numericValueValidation(String val) {
    var n = int.tryParse(val) ?? double.tryParse(val);
    if (val.isEmpty) {
      return "Please Enter Somthing";
    } else if (n == null) {
      return "Please Enter only Numeric Value";
    }
  }

  static emailValidation(String value) {
    if (value.isEmpty) {
      // The form is empty
      return "Enter email address";
    }
    // This is just a regular expression for email addresses
    String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
        "\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        ")+";
    RegExp regExp = new RegExp(p);

    if (regExp.hasMatch(value)) {
      // So, the email is valid
      return null;
    }

    // The pattern of the email didn't match the regex above.
    return 'Email is not valid';
  }
}
