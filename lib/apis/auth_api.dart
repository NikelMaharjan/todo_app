import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';

class AuthApi {

  Future<String?> loginWithFirebase(String email, String password) async {
    try {
      UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final user = credential.user;
      if (user == null) return null;
      final uid = user.uid;  //firebase id // to store user info
      return uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        throw Exception('Wrong password provided for that user.');
      }
    }
  }

  Future<String?> registerWithFirebase(String name, String phone, String email, String password) async {

    try {
      UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = credential.user;
      if (user == null) return null;
      final uid = user.uid;  //to store user infooo
      await storeUserInfo(uid, name, phone, email);
      return uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        throw Exception('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        throw Exception('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }


  Future<String?> storeUserInfo(String uid, String name, String phone, String email) async {

    var root = "https://todo-1b5db-default-rtdb.firebaseio.com/users/$uid.json";
    Map<String, dynamic> requestBody = {
      "email": email,
      "name": name,
      "phone": phone,
    };
    try {
      final uri = Uri.parse(root);
      final response = await put(uri, body: jsonEncode(requestBody));
      if (response.statusCode != 200) {
        return null;
      }
      var body = jsonDecode(response.body);
      print("Store user info $body");
      if (body["name"] == null) {
        return null;
      }
      return body["name"];
    } catch (e) {
      print("Storing userinfo error $e");
      return null;
    }
  }

 /* Future<UserModel?> login(String email, String password) async {
    Map<String, dynamic> requestBody = {
      "email": email,
      "password": password,
      "gender": "none"
    };
    try {
      var uri = Uri.parse("https://api.fresco-meat.com/api/albums/signup");
      final response = await post(
        uri,
        body: jsonEncode(requestBody),
        headers: {"Content-Type": "application/json"},
      );
      final body = response.body;
      print("login response $body");
      if (response.statusCode != 201) return null;
      final parsedMap = jsonDecode(body);
      final user = UserModel.fromJson(parsedMap);
      return user;
    } catch (e) {
      print("login exception $e");
      return null;
    }
  }
  Future<UserModel?> register(String name, String phone, String email, String password) async {
    Map<String, dynamic> requestBody = {
      "email": email,
      "password": password,
      "name": name,
      "phone": phone,
    };
    try {
      var uri = Uri.parse("https://api.fresco-meat.com/api/albums/signup");
      final response = await post(
        uri,
        body: jsonEncode(requestBody),
        headers: {"Content-Type": "application/json"},
      );
      final body = response.body;
      print("Signup response $body");
      if (response.statusCode != 201) return null;
      final parsedMap = jsonDecode(body);
      final user = UserModel.fromJson(parsedMap);
      return user;
    } catch (e) {
      print("Sigup exception $e");
      return null;
    }
  }*/
}
