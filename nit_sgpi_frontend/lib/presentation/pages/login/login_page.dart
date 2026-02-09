import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/presentation/pages/login/controllers/login_controller.dart';

import '../../shared/widgets/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController(
    text: 'marialurdes123@gmail.com',
  );
  final _passwordController = TextEditingController(text: 'marialurdes123');
  final loginController = Get.find<LoginController>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("assets/images/Logo SGPI-Photoroom 1.png"),
              Text(
                'NIT',
                style: context.textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Campo Email
              CustomTextField(label: "LOGIN", controller: _emailController, size: 447,),
              const SizedBox(height: 16),
              // Campo Senha
              CustomTextField(
                label: "SENHA",
                controller: _passwordController,
                obscureText: true,
                size: 447,
              ),
              const SizedBox(height: 24),
              // Erro
              Obx(() {
                final error = loginController.errorMessage.value;
                if (error.isEmpty) {
                  return const SizedBox(height: 20);
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(error, style: const TextStyle(color: Colors.red)),
                );
              }),

              Obx(
                () => SizedBox(
                  width: 447,
                  height: 44,
                  child: ElevatedButton(
                    style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.onSecondary)),
                    onPressed: loginController.loading.value
                        ? null
                        : () {
                            loginController.login(
                              _emailController.text,
                              _passwordController.text,
                            );
                          },
                    child: loginController.loading.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text("Login"),
                  ),
                ),
              ), 
              SizedBox(height: 23),
              Row(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,children: [
                Text("Nao tem cadastro ? ", style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.onSecondary)),
                TextButton(onPressed: (){
                  Get.toNamed("/register");
                },child: Text("Fazer cadastro",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.yellow)))
              ],)
            ],
          ),
        ),
      ),
    );
  }
}
