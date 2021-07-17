import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:todo_bloc/blocs/auth_bloc.dart';
import 'package:todo_bloc/blocs/auth_bloc_provider.dart';

import 'app_colors.dart';

class InputEmail extends StatelessWidget {
  final TextEditingController controller;

  const InputEmail({Key? key, required this.controller}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = AuthBlocProvider.of(context);
    return Container(
        margin: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 12.0),
              child: Text(
                "Your email",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
              ),
            ),
            StreamBuilder(
                stream: authBloc.emailStream,
                builder: (context, AsyncSnapshot<String> snapshot) {
                  return TextField(
                    controller: controller,
                    onChanged: authBloc.changeEmail,
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 16.0),
                        prefixIcon: Container(
                            width: Math.min(
                                MediaQuery.of(context).size.width / 6, 40),
                            decoration: BoxDecoration(
                                border: Border(
                                    right: BorderSide(color: greyColor))),
                            child: Text(
                              "@",
                              textAlign: TextAlign.center,
                            ),
                            padding: EdgeInsets.all(8),
                            alignment: Alignment.center),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: blackColor87, width: 1),
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(4.0),
                          ),
                        ),
                        hintText: "you@example.com",
                        errorText: snapshot.hasError
                            ? snapshot.error.toString()
                            : null),
                  );
                })
          ],
        ));
  }
}
