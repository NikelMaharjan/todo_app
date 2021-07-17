import 'package:flutter/material.dart';

import 'app_colors.dart';

AppBar buildCustomAppBar(
    {Widget leading = const Icon(Icons.close),
    String? title,
    String? subTitle,
    required BuildContext context}) {
  return AppBar(
    leading: leading,
    titleSpacing: 0,
    backgroundColor: whiteColor,
    title: title == null
        ? Container()
        : Text(
            title,
            style: Theme.of(context)
                .textTheme
                .button!
                .copyWith(fontSize: 18, color: Colors.black),
          ),
    bottom: PreferredSize(
        child: Container(
          padding: EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 4),
          margin: EdgeInsets.only(bottom: 20),
          height: kToolbarHeight * 1.7,
          width: MediaQuery.of(context).size.width,
          child: subTitle == null
              ? Container()
              : Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            subTitle,
                            style: Theme.of(context)
                                .textTheme
                                .headline4!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: blackColor87),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
        preferredSize: Size.fromHeight(kToolbarHeight * 1.6 + 16)),
  );
}
