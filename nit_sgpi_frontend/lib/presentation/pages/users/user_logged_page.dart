import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/presentation/pages/users/controllers/user_logged_controller.dart';
import 'package:nit_sgpi_frontend/presentation/shared/utils/responsive.dart';

class UserLoggedPage extends StatelessWidget {
  const UserLoggedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserLoggedController>();

    return Scaffold(
      body: Container(
        margin: Responsive.getPadding(context),
        child: Obx(() {
          if (controller.isLoading.value) {
            return CircularProgressIndicator();
          }

          if (controller.errorMessage.isNotEmpty) {
            return Text(controller.errorMessage.value);
          }

          final user = controller.user.value;

          if (user == null) {
            return Text("Nenhum usuário encontrado");
          }

          return Column(
            children: [Text(user.fullName), Text(user.email), Text(user.role)],
          );
        }),
      ),
    );
  }
}
