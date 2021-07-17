import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_bloc/blocs/auth_bloc_provider.dart';
import 'package:todo_bloc/blocs/cache_bloc.dart';
import 'package:todo_bloc/screens/login_screen.dart';
import 'package:todo_bloc/screens/todo_screen.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await cache.setup();  //await// check if there is value or not??
  bool isLoggedIn = cache.currentUid != null;

  runApp(MyApp(isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp(this.isLoggedIn);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Todo App",
      theme: ThemeData(canvasColor: Colors.grey[200]
      ),
     home: isLoggedIn ? TodoScreen() : AuthBlocProvider(child: LoginScreen()),
    );
  }
}

