import 'dart:async';

import 'package:rxdart/rxdart.dart' show BehaviorSubject, Rx;
import 'package:todo_bloc/apis/auth_api.dart';
import 'package:todo_bloc/blocs/cache_bloc.dart';
import 'package:todo_bloc/validators/auth_validator.dart';

class AuthBloc with AuthValidator {
  final api = AuthApi();

  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  //to hold the status of the button's child
  final _loadingController = BehaviorSubject<bool>();

  ///signup part is also fused here
  final _nameController = BehaviorSubject<String>();
  final _phoneController = BehaviorSubject<String>();

  //getters for Functions
  // void  changeEmail(val) { _emailController.sink.add(val);}
  Function(String pass) get changeEmail => _emailController.sink.add;

  Function(String pass) get changePassword => _passwordController.sink.add;

  Function(bool val) get changeLoadingStatus => _loadingController.sink.add;

  Function(String val) get changeName => _nameController.sink.add;

  Function(String val) get changePhone => _phoneController.sink.add;

  //stream getters
  Stream<String> get emailStream =>
      _emailController.stream.transform(emailValidator);

  Stream<String> get passwordStream =>
      _passwordController.stream.transform(passwordValidator);

  Stream<String> get nameStream =>
      _nameController.stream.transform(nameValidator);

  Stream<String> get phoneStream =>
      _phoneController.stream.transform(phoneValidator);

  Stream<bool> get loadingStatusStream => _loadingController.stream;

  // combine 2 streams for login button
  Stream<bool> get buttonStreamForLogin =>
      Rx.combineLatest2(emailStream, passwordStream, (a, b) => true);

  // combine 4 streams for signup button
  Stream<bool> get buttonStreamForSignup =>
      Rx.combineLatest4(emailStream,
          passwordStream, phoneStream, nameStream, (a, b, c, d) => true);

  Future login() async {
    final email = _emailController.value;
    final password = _passwordController.value;
    final response = await api.loginWithFirebase(email, password); //uid return from auth api
    if(response!=null){
      cache.loadData(response);
    }
    return response;
    }

    Future register() async {
      final email = _emailController.value;
      final password = _passwordController.value;
      final name = _nameController.value;
      final phone = _phoneController.value;
      final response = await api.registerWithFirebase(name, phone, email, password);  //uid return from auth api
      if(response!=null){
        cache.loadData(response);
      }
      return response;
    }

    void dispose() {
      _emailController.close();
      _passwordController.close();
      _loadingController.close();
      _nameController.close();
      _phoneController.close();
    }
  }
