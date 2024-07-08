class ValidateCheckingFun {
  static String? validateEmail(String? value) {
    const emailPattern = r'^[^@]+@[^@]+\.[^@]+';
    final regex = RegExp(emailPattern);
    if (value == null || value.isEmpty) {
      return "Please enter your email";
    } else if (!regex.hasMatch(value)) {
      return "Please enter a valid email";
    }
    return null;
  }

  static String? validatePassword(String? value) {
    const passwordPattern =
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>])[A-Za-z\d!@#$%^&*(),.?":{}|<>]{8,}$';
    final regex = RegExp(passwordPattern);
    if (value == null || value.trim().isEmpty) {
      return "Please enter your password";
    } else if (!regex.hasMatch(value)) {
      return "Must 8 characters, one uppercase and lowercase\n letter, a number, and a symbol.";
    }
    return null;
  }

  static String? validateFirstName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter your first name";
    }
    return null;
  }

  static String? validateLastName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter your last name";
    }
    return null;
  }

  static String? validateNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter your mobile number";
    }
    if (value.length != 11) {
      return "Please enter 11 digit valid number";
    }
    return null;
  }

  static String? validatePinVerification(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter 6 digit pin";
    }
    if (value.length != 6) {
      return "Please must enter 6 digit pin";
    }
    return null;
  }
}