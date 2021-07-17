import 'package:flutter/material.dart';
import 'package:todo_bloc/blocs/todo_bloc.dart';

class TodoBlocProvider extends InheritedWidget {
  final bloc = TodoBloc();
  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  TodoBlocProvider({Key? key, required Widget child})
      : super(key: key, child: child);

  static TodoBloc of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<TodoBlocProvider>();
    return result!.bloc;
  }
}
