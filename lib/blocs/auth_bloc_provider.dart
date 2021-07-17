import 'package:flutter/material.dart';

import 'auth_bloc.dart';

class AuthBlocProvider extends InheritedWidget {
  final bloc = AuthBloc();
  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  AuthBlocProvider({Key? key, required Widget child})
      : super(key: key, child: child);

  static AuthBloc of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<AuthBlocProvider>();
    return result!.bloc;
  }
}
