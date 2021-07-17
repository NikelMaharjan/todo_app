import 'dart:async';

class TodoValidator {
  final nameValidator =
  StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (name.length > 4) {
      sink.add(name);
    } else {
      sink.addError("Name must be at least 4 characters long");
    }
  });
  final descriptionValidator =
  StreamTransformer<String, String>.fromHandlers(handleData: (phone, sink) {
    if (phone.length > 9) {
      sink.add(phone);
    } else {
      sink.addError("Description must be at least 9 characters long");
    }
  });

  final dateValidator = StreamTransformer<DateTime, DateTime>.fromHandlers(
      handleData: (DateTime date, sink) {
        final today = DateTime.now();

        if (date.isAfter(today)) {
          sink.add(date);
        } else {
          sink.addError("Completion date should be in future.");
        }
      });
}
