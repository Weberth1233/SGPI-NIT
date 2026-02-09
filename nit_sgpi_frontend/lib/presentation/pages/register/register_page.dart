import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/infra/models/process/user_model.dart';
import 'package:nit_sgpi_frontend/infra/models/user/address_model.dart';
import 'package:nit_sgpi_frontend/infra/models/user/user_post_model.dart';
import 'package:nit_sgpi_frontend/presentation/pages/register/controllers/register_controller.dart';
import 'package:nit_sgpi_frontend/presentation/shared/widgets/custom_text_field.dart';

import '../../shared/utils/responsive.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final registerController = Get.find<RegisterController>();

    TextEditingController nameController = TextEditingController();
    TextEditingController userController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController professionController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    TextEditingController birthdateController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController cepController = TextEditingController();
    TextEditingController streetController = TextEditingController();
    TextEditingController numberController = TextEditingController();
    TextEditingController complementController = TextEditingController();
    TextEditingController neighborhoodController = TextEditingController();
    TextEditingController cityController = TextEditingController();
    TextEditingController stateController = TextEditingController();

    return Obx(() {
      // Escuta a mensagem e mostra o popup
      if (registerController.message.value.isNotEmpty) {
        Future.microtask(() {
          Get.snackbar(
            "Cadastro",
            registerController.message.value,
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 3),
          );
          // limpa para não repetir
          registerController.message.value = "";
        });
      }

      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        body: SingleChildScrollView(
          child: Container(
            padding: Responsive.getPadding(context),
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  Row(
                    spacing: 20,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: IconButton(
                          onPressed: () {
                            Get.toNamed("/login");
                          },
                          icon: const Icon(Icons.arrow_back, size: 30),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Cadastro de usuários",
                          style: Theme.of(context).textTheme.headlineSmall!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "Insira os dados do usuário para se cadastrar no sistema",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 20),

                  Row(
                    spacing: 5,
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: nameController,
                          label: "Nome Completo",
                        ),
                      ),
                      Expanded(
                        child: CustomTextField(
                          controller: userController,
                          label: "Nome de usuário",
                        ),
                      ),
                    ],
                  ),
                  CustomTextField(controller: emailController, label: "E-mail"),
                  Row(
                    spacing: 5,
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: professionController,
                          label: "Profissão",
                        ),
                      ),
                      Expanded(
                        child: CustomTextField(
                          controller: phoneController,
                          label: "Telefone",
                        ),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 5,
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: birthdateController,
                          label: "Data de nascimento",
                        ),
                      ),
                      Expanded(
                        child: CustomTextField(
                          controller: passwordController,
                          label: "Senha",
                        ),
                      ),
                    ],
                  ),
                  const Divider(thickness: 0.2),
                  Text(
                    "Dados de endereço do usuário",
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Insira seus dados de enderço para finalizar o cadastro no sistema",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Row(
                    spacing: 5,
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: cepController,
                          label: "CEP",
                        ),
                      ),
                      Expanded(
                        child: CustomTextField(
                          controller: streetController,
                          label: "Rua",
                        ),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 5,
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: numberController,
                          label: "Numero",
                        ),
                      ),
                      Expanded(
                        child: CustomTextField(
                          controller: complementController,
                          label: "Complemento",
                        ),
                      ),
                    ],
                  ),
                  CustomTextField(
                    controller: neighborhoodController,
                    label: "Setor",
                  ),
                  Row(
                    spacing: 5,
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: cityController,
                          label: "Cidade",
                        ),
                      ),
                      Expanded(
                        child: CustomTextField(
                          controller: stateController,
                          label: "Estado",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  Container(
                    margin: const EdgeInsets.only(bottom: 30),
                    child: Row(
                      children: [
                        const Expanded(child: SizedBox()),
                        Obx(() {
                          return ElevatedButton(
                            onPressed: registerController.isLoading.value
                                ? null
                                : () {
                                    registerController.post(
                                      UserPostModel(
                                        userName: userController.text,
                                        email: emailController.text,
                                        password: passwordController.text,
                                        phoneNumber: phoneController.text,
                                        birthDate: birthdateController.text,
                                        profession: professionController.text,
                                        fullName: nameController.text,
                                        role: "USER",
                                        isEnabled: true,
                                        address: AddressModel(
                                          zipCode: cepController.text,
                                          street: stateController.text,
                                          number: numberController.text,
                                          complement: complementController.text,
                                          neighborhood:
                                              neighborhoodController.text,
                                          city: cityController.text,
                                          state: stateController.text,
                                        ),
                                      ),
                                    );
                                  },
                            child: registerController.isLoading.value
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    "Salvar dados",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSecondary,
                                        ),
                                  ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
