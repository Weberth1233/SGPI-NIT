import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/domain/entities/user/address_entity.dart';
import 'package:nit_sgpi_frontend/domain/entities/user/user_entity.dart';
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

  bool _showPassword = false;

  void _openBeautifulDatePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SizedBox(
          height: 300,
          child: SfDateRangePicker(
            backgroundColor: Theme.of(context).colorScheme.surface,

            selectionColor: Theme.of(context).colorScheme.primary,
            todayHighlightColor: Theme.of(context).colorScheme.primary,

            headerStyle: DateRangePickerHeaderStyle(
              textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),

            // ===== DIAS (já estava)
            monthCellStyle: DateRangePickerMonthCellStyle(
              textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.tertiary,
                fontWeight: FontWeight.w600,
              ),
              todayTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.tertiary,
                fontWeight: FontWeight.w800,
              ),
            ),

            // ===== ANOS / DÉCADAS (novo)
            yearCellStyle: DateRangePickerYearCellStyle(
              textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.tertiary,
                fontWeight: FontWeight.w600,
              ),
              todayTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.tertiary,
                fontWeight: FontWeight.w800,
              ),
            ),

            onSelectionChanged: (args) {
              final value = args.value;
              if (value is! DateTime) return;

              final date = value;
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

  // =======================
  // UI helpers
  // =======================
  Widget _sectionHeader(BuildContext context, String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 4),
        Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _cardSection(BuildContext context, {required Widget child}) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: theme.dividerColor.withOpacity(0.12)),
      ),
      child: child,
    );
  }

  Widget _gap() => const SizedBox(height: 10);

  @override
  Widget build(BuildContext context) {
    final registerController = Get.find<RegisterController>();
    final theme = Theme.of(context);

    return Obx(() {
      if (registerController.message.value.isNotEmpty) {
        Future.microtask(() {
          Get.snackbar(
            "Cadastro",
            registerController.message.value,
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 3),
            backgroundColor: theme.colorScheme.onPrimary,
            colorText: theme.colorScheme.primary,
            margin: const EdgeInsets.all(12),
            borderRadius: 12,
          );
          registerController.message.value = "";
        });
      }

      return Scaffold(
        backgroundColor: theme.colorScheme.primary,
        body: SingleChildScrollView(
          child: Container(
            padding: Responsive.getPadding(context),
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ===== Top bar
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onSurface,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: IconButton(
                            onPressed: () => Get.toNamed("/login"),
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
                            "Cadastro de usuários",
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // ===== Seção: Dados pessoais
                    _cardSection(
                      context,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionHeader(
                            context,
                            "Dados do usuário",
                            "Preencha as informações para criar sua conta.",
                          ),

                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  controller: nameController,
                                  label: "Nome completo",
                                  validator: (v) => Validators.required(
                                    v,
                                    message: "Informe o nome completo",
                                  ),
                                  prefixIcon: const Icon(Icons.badge_outlined),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: CustomTextField(
                                  controller: userController,
                                  label: "Nome de usuário",
                                  validator: (v) => Validators.required(
                                    v,
                                    message: "Informe o nome de usuário",
                                  ),
                                  prefixIcon: const Icon(Icons.alternate_email),
                                ),
                              ),
                            ],
                          ),

                          _gap(),

                          CustomTextField(
                            controller: emailController,
                            label: "E-mail",
                            keyboardType: TextInputType.emailAddress,
                            validator: Validators.email,
                            prefixIcon: const Icon(Icons.mail_outline),
                          ),

                          _gap(),

                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  controller: professionController,
                                  label: "Profissão",
                                  validator: Validators.required,
                                  prefixIcon: const Icon(Icons.work_outline),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: CustomTextField(
                                  controller: phoneController,
                                  label: "Telefone",
                                  keyboardType: TextInputType.phone,
                                  validator: Validators.phone,
                                  prefixIcon: const Icon(Icons.phone_outlined),
                                ),
                              ),
                            ],
                          ),

                          _gap(),

                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  controller: birthdateController,
                                  label: "Data de nascimento",
                                  validator: Validators.required,
                                  onTap: () =>
                                      _openBeautifulDatePicker(context),
                                  readOnly: true,
                                  prefixIcon: const Icon(Icons.cake_outlined),
                                  suffixIcon: IconButton(
                                    onPressed: () =>
                                        _openBeautifulDatePicker(context),
                                    icon: const Icon(Icons.calendar_month),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 10),
                              Expanded(
                                child: CustomTextField(
                                  controller: passwordController,
                                  label: "Senha",
                                  obscureText: !_showPassword,
                                  validator: (v) => Validators.minLength(
                                    v,
                                    6,
                                    message:
                                        "Senha deve ter no mínimo 6 caracteres",
                                  ),
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    onPressed: () => setState(() {
                                      _showPassword = !_showPassword;
                                    }),
                                    icon: Icon(
                                      _showPassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // ===== Seção: Endereço
                    _cardSection(
                      context,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionHeader(
                            context,
                            "Endereço",
                            "Informe seu endereço para concluir o cadastro.",
                          ),

                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  controller: cepController,
                                  label: "CEP",
                                  keyboardType: TextInputType.number,
                                  validator: Validators.cep,
                                  prefixIcon: const Icon(
                                    Icons.pin_drop_outlined,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: CustomTextField(
                                  controller: streetController,
                                  label: "Rua",
                                  validator: Validators.required,
                                  prefixIcon: const Icon(
                                    Icons.signpost_outlined,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          _gap(),

                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  controller: numberController,
                                  label: "Número",
                                  keyboardType: TextInputType.number,
                                  validator: Validators.required,
                                  prefixIcon: const Icon(
                                    Icons.confirmation_number_outlined,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: CustomTextField(
                                  controller: complementController,
                                  label: "Complemento (opcional)",
                                  validator: (v) => null,
                                  prefixIcon: const Icon(
                                    Icons.add_location_alt_outlined,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          _gap(),

                          CustomTextField(
                            controller: neighborhoodController,
                            label: "Setor / Bairro",
                            validator: Validators.required,
                            prefixIcon: const Icon(Icons.map_outlined),
                          ),

                          _gap(),

                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  controller: cityController,
                                  label: "Cidade",
                                  validator: Validators.required,
                                  prefixIcon: const Icon(
                                    Icons.location_city_outlined,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: CustomTextField(
                                  controller: stateController,
                                  label: "Estado",
                                  validator: Validators.required,
                                  prefixIcon: const Icon(Icons.flag_outlined),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ===== CTA
                    Container(
                      margin: const EdgeInsets.only(bottom: 30),
                      child: Obx(() {
                        return SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton.icon(
                            icon: registerController.isLoading.value
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.save_outlined),
                            onPressed: registerController.isLoading.value
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      registerController.post(
                                        UserEntity(
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
                            label: Text(
                              registerController.isLoading.value
                                  ? "Salvando..."
                                  : "Salvar cadastro",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        );
                      }),
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
