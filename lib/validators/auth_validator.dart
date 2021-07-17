import 'dart:async';

class AuthValidator {
  final emailValidator =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.contains("@") && email.contains(".")) {
      sink.add(email);
    } else {
      sink.addError("Invalid email address");
    }
  });

  final passwordValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length > 4) {
      sink.add(password);
    } else {
      sink.addError("Password must be at least 4 characters long");
    }
  });
  final nameValidator =
      StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (name.length > 4) {
      sink.add(name);
    } else {
      sink.addError("Name must be at least 4 characters long");
    }
  });
  final phoneValidator =
      StreamTransformer<String, String>.fromHandlers(handleData: (phone, sink) {
    if (phone.length > 9) {
      sink.add(phone);
    } else {
      sink.addError("Phone must be at least 9 characters long");
    }
  });
}
