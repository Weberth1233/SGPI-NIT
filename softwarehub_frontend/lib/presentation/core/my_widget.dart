import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../shared/theme/my_theme.dart';
import 'routes/my_routes.dart';


class MyWidget extends StatelessWidget {
  final String initialRoute;
  const MyWidget({super.key,required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "SOFTWAREHUB",
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      getPages: MyRoutes.pages,
      theme: MyTheme.defaultTheme,
    );
  }
}