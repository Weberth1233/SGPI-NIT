import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/entities/user/address_entity.dart';
import '../../../domain/entities/user/user_entity.dart';
import '../../shared/utils/responsive.dart';
import '../../shared/utils/validators.dart';
import '../../shared/widgets/custom_text_field.dart';
import '../users/controllers/user_logged_controller.dart';
import 'controllers/register_controller.dart';

class RegisterPage extends StatefulWidget {
  final bool isEditMode;

  const RegisterPage({
    super.key,
    this.isEditMode = false,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final registerController = Get.find<RegisterController>();
  final userControllerGet = Get.find<UserLoggedController>();

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

  @override
  void initState() {
    super.initState();

    if (widget.isEditMode) {
      userControllerGet.fetchLoggedUser();

      ever(userControllerGet.user, (user) {
        if (user != null) {
          _fillForm(user);
        }
      });
    }
  }

  void _fillForm(UserEntity user) {
    nameController.text = user.fullName;
    userController.text = user.userName;
    emailController.text = user.email;
    professionController.text = user.profession;
    phoneController.text = user.phoneNumber;
    birthdateController.text = user.birthDate;

    cepController.text = user.address.zipCode;
    streetController.text = user.address.street;
    numberController.text = user.address.number;
    complementController.text = user.address.complement ?? '';
    neighborhoodController.text = user.address.neighborhood;
    cityController.text = user.address.city;
    stateController.text = user.address.state;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final user = UserEntity(
      id: widget.isEditMode ? userControllerGet.user.value?.id : null,
      userName: userController.text,
      email: emailController.text,
      password: passwordController.text,
      phoneNumber: phoneController.text,
      birthDate: birthdateController.text,
      profession: professionController.text,
      fullName: nameController.text,
      role: "USER",
      isEnabled: true,
      address: AddressEntity(
        zipCode: cepController.text,
        street: streetController.text,
        number: numberController.text,
        complement: complementController.text,
        neighborhood: neighborhoodController.text,
        city: cityController.text,
        state: stateController.text,
      ),
    );

    if (widget.isEditMode) {
      // registerController.update(user);
    } else {
      registerController.post(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
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
                            onPressed: () => Get.back(),
                            icon: const Icon(Icons.arrow_back, size: 30),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            widget.isEditMode
                                ? "Editar usuário"
                                : "Cadastro de usuários",
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),

                    Text(
                      widget.isEditMode
                          ? "Atualize seus dados no sistema"
                          : "Insira os dados do usuário para se cadastrar no sistema",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 20),

                    /// ====== MANTIVE SUA ESTRUTURA ORIGINAL ======

                    Row(
                      spacing: 5,
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: nameController,
                            label: "Nome Completo",
                            validator: (v) =>
                                Validators.required(v),
                          ),
                        ),
                        Expanded(
                          child: CustomTextField(
                            controller: userController,
                            label: "Nome de usuário",
                            validator: (v) =>
                                Validators.required(v),
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
                          ),
                        ),
                        if (!widget.isEditMode)
                          Expanded(
                            child: CustomTextField(
                              controller: passwordController,
                              label: "Senha",
                              obscureText: true,
                              validator: (v) => Validators.minLength(v, 6),
                            ),
                          ),
                      ],
                    ),

                    const Divider(thickness: 0.2),

                    Text(
                      "Dados de Endereço",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(fontWeight: FontWeight.bold),
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

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        const Expanded(child: SizedBox()),
                        ElevatedButton(
                          onPressed: registerController.isLoading.value
                              ? null
                              : _submit,
                          child: registerController.isLoading.value
                              ? const CircularProgressIndicator()
                              : Text(
                                  widget.isEditMode
                                      ? "Atualizar dados"
                                      : "Salvar dados",
                                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.onSecondary),
                                ),
                        ),
                      ],
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
