import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../shared/controller/auth_controller.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();

    if (!authController.isAuthenticated) {
      return const RouteSettings(name: '/');
    }

    return null;
  }
}