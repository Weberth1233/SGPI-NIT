import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/presentation/core/routes/my_routes.dart';
import 'package:nit_sgpi_frontend/presentation/shared/theme/my_theme.dart';

class MyWidget extends StatelessWidget {
  final String initialRoute;
  const MyWidget({super.key,required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "SGPI",
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      getPages: MyRoutes.pages,
      theme: MyTheme.defaultTheme,
    );
  }
}