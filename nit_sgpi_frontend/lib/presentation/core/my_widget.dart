import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/presentation/core/routes/my_routes.dart';
import 'package:nit_sgpi_frontend/presentation/shared/theme/my_theme.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "SGPI",
      debugShowCheckedModeBanner: false,
      initialRoute: MyRoutes.initialRoute,
      getPages: MyRoutes.pages,
      theme: MyTheme.defaultTheme,
    );
  }
}