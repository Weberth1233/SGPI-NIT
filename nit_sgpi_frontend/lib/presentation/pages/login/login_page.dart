import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/presentation/pages/login/controllers/login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController(text: 'marialurdes123@gmail.com');
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
          width: 360,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               Text(
                'Login',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.onSecondary)
              ),
              const SizedBox(height: 24),
        
              // Campo Email
              TextField(
                controller: _emailController,
                decoration:  InputDecoration(
                  labelText: 'Email',
                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // Campo Senha
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration:  InputDecoration(
                  labelText: 'Senha',
                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                  border: OutlineInputBorder(),
                ),
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
                  child: Text(
                    error,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }),
        
              Obx(
                () => ElevatedButton(
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
                      : const Text('Entrar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
