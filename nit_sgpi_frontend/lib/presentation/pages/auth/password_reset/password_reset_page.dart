import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/presentation/pages/auth/password_reset/controllers/password_reset_controller.dart';

import '../../../shared/widgets/custom_text_field.dart';

class PasswordResetPage extends StatelessWidget {
  const PasswordResetPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController _tokenController = TextEditingController();
    TextEditingController _newPasswordController = TextEditingController();
    final passwordResetController = Get.find<PasswordResetController>();

    final theme = Theme.of(context);
    // final forgotPasswordController = Get.find<ForgotPasswordController>();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 30),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(
                        Icons.arrow_back,
                        size: 26,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Trocar de senha",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.surface,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                height: 500,
                width: 500,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Trocar de senha", style: theme.textTheme.bodyLarge),
                    SizedBox(height: 5),
                    Text(
                      "Informe o codigo que enviamos para seu e-mail e sua nova senha!",
                    ),
                    SizedBox(height: 50),

                    CustomTextField(
                      controller: _tokenController,
                      label: "Codigo:",
                    ),
                    SizedBox(height: 20),
                    CustomTextField(
                      controller: _newPasswordController,
                      label: "Nova senha:",
                      obscureText: true,
                    ),
                    SizedBox(height: 10),

                    Obx(
                      () => SizedBox(
                        width: 447,
                        height: 44,
                        child: ElevatedButton(
                          onPressed: passwordResetController.loading.value
                              ? null
                              : () {
                                  passwordResetController.passwordReset(
                                    _tokenController.text,
                                    _newPasswordController.text,
                                  );
                                  _tokenController.clear();
                                  _newPasswordController.clear();
                                },
                          child: passwordResetController.loading.value
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.amber,
                                  ),
                                )
                              : Text(
                                  "Enviar",
                                  style: theme.textTheme.bodySmall!.copyWith(
                                    color: theme.colorScheme.onSecondary,
                                  ),
                                ),
                        ),
                      ),
                    ),

                    Obx(() {
                      final message = passwordResetController.message.value;
                      if (message.isEmpty) return const SizedBox(height: 20);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          message,
                          style: const TextStyle(color: Colors.black),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
