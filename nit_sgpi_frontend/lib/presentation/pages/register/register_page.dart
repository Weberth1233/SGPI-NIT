import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/domain/entities/user/address_entity.dart';
import 'package:nit_sgpi_frontend/domain/entities/user/user_post_entity.dart';
import 'package:nit_sgpi_frontend/infra/models/user/address_model.dart';
import 'package:nit_sgpi_frontend/infra/models/user/user_post_model.dart';
import 'package:nit_sgpi_frontend/presentation/pages/register/controllers/register_controller.dart';
import 'package:nit_sgpi_frontend/presentation/shared/widgets/custom_text_field.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../shared/utils/responsive.dart';
import '../../shared/utils/validators.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController userController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController professionController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final TextEditingController cepController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController complementController = TextEditingController();
  final TextEditingController neighborhoodController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();

  void _openBeautifulDatePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SizedBox(
          height: 400,
          child: SfDateRangePicker(
            onSelectionChanged: (args) {
              final DateTime date = args.value;
              birthdateController.text =
                  "${date.day.toString().padLeft(2, '0')}/"
                  "${date.month.toString().padLeft(2, '0')}/"
                  "${date.year}";
              Navigator.pop(context);
            },
            selectionMode: DateRangePickerSelectionMode.single,
            showActionButtons: false,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    userController.dispose();
    emailController.dispose();
    professionController.dispose();
    phoneController.dispose();
    birthdateController.dispose();
    passwordController.dispose();

    cepController.dispose();
    streetController.dispose();
    numberController.dispose();
    complementController.dispose();
    neighborhoodController.dispose();
    cityController.dispose();
    stateController.dispose();
    super.dispose();
  }

  void clearForm() {
      userController.clear();
      nameController.clear();
      emailController.clear();
      professionController.clear();
      phoneController.clear();
      birthdateController.clear();
      passwordController.clear();

      cepController.clear();
      streetController.clear();
      numberController.clear();
      complementController.clear();
      neighborhoodController.clear();
      cityController.clear();
      stateController.clear();
    }

  @override
  Widget build(BuildContext context) {
    final registerController = Get.find<RegisterController>();

    

    return Obx(() {
      if (registerController.message.value.isNotEmpty) {
        Future.microtask(() {
          Get.snackbar(
            "Cadastro",
            registerController.message.value,
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 3),
            backgroundColor: Theme.of(context).colorScheme.primary,
          );
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
              child: Form(
                key: _formKey,
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
                            validator: (v) => Validators.required(
                              v,
                              message: "Informe o nome completo",
                            ),
                          ),
                        ),
                        Expanded(
                          child: CustomTextField(
                            controller: userController,
                            label: "Nome de usuário",
                            validator: (v) => Validators.required(
                              v,
                              message: "Informe o nome de usuário",
                            ),
                          ),
                        ),
                      ],
                    ),

                    CustomTextField(
                      controller: emailController,
                      label: "E-mail",
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.email,
                    ),

                    Row(
                      spacing: 5,
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: professionController,
                            label: "Profissão",
                            validator: Validators.required,
                          ),
                        ),
                        Expanded(
                          child: CustomTextField(
                            controller: phoneController,
                            label: "Telefone",
                            keyboardType: TextInputType.phone,
                            validator: Validators.phone,
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
                            validator: Validators.required,
                            onTap: () => _openBeautifulDatePicker(context),
                          ),
                        ),
                        Expanded(
                          child: CustomTextField(
                            controller: passwordController,
                            label: "Senha",
                            obscureText: true,
                            validator: (v) => Validators.minLength(
                              v,
                              6,
                              message: "Senha deve ter no mínimo 6 caracteres",
                            ),
                          ),
                        ),
                      ],
                    ),

                    const Divider(thickness: 0.2),

                    Text(
                      "Dados de Endereço",
                      style: Theme.of(context).textTheme.headlineSmall!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Insira seus dados de endereço para finalizar o cadastro no sistema",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),

                    Row(
                      spacing: 5,
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: cepController,
                            label: "CEP",
                            keyboardType: TextInputType.number,
                            validator: Validators.cep,
                          ),
                        ),
                        Expanded(
                          child: CustomTextField(
                            controller: streetController,
                            label: "Rua",
                            validator: Validators.required,
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
                            label: "Número",
                            keyboardType: TextInputType.number,
                            validator: Validators.required,
                          ),
                        ),
                        Expanded(
                          child: CustomTextField(
                            controller: complementController,
                            label: "Complemento",
                            validator: (v) => null, // opcional
                          ),
                        ),
                      ],
                    ),

                    CustomTextField(
                      controller: neighborhoodController,
                      label: "Setor",
                      validator: Validators.required,
                    ),

                    Row(
                      spacing: 5,
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: cityController,
                            label: "Cidade",
                            validator: Validators.required,
                          ),
                        ),
                        Expanded(
                          child: CustomTextField(
                            controller: stateController,
                            label: "Estado",
                            validator: Validators.required,
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
                                      if (_formKey.currentState!.validate()) {
                                        registerController.post(
                                          UserPostEntity(
                                            userName: userController.text,
                                            email: emailController.text,
                                            password: passwordController.text,
                                            phoneNumber: phoneController.text,
                                            birthDate: birthdateController.text,
                                            profession:
                                                professionController.text,
                                            fullName: nameController.text,
                                            role: "USER",
                                            isEnabled: true,
                                            address: AddressEntity(
                                              zipCode: cepController.text,
                                              street: streetController.text,
                                              number: numberController.text,
                                              complement:
                                                  complementController.text,
                                              neighborhood:
                                                  neighborhoodController.text,
                                              city: cityController.text,
                                              state: stateController.text,
                                            ),
                                          ),
                                        );
                                        clearForm();
                                      }
                                      
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
        ),
      );
    });
  }
}
