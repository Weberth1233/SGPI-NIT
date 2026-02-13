import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/domain/entities/user/address_entity.dart';
import 'package:nit_sgpi_frontend/domain/entities/user/user_entity.dart';
import 'package:nit_sgpi_frontend/presentation/pages/register/controllers/register_controller.dart';
import 'package:nit_sgpi_frontend/presentation/shared/widgets/custom_text_field.dart';
import '../../shared/utils/responsive.dart';
import '../../shared/utils/validators.dart';
import 'package:flutter/services.dart';

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
  final TextEditingController passwordController = TextEditingController();

  final TextEditingController cepController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController complementController = TextEditingController();
  final TextEditingController neighborhoodController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();

  // Data de nascimento (manual)
  final TextEditingController birthDayController = TextEditingController();
  final TextEditingController birthMonthController = TextEditingController();
  final TextEditingController birthYearController = TextEditingController();

  bool _showPassword = false;

  @override
  void dispose() {
    nameController.dispose();
    userController.dispose();
    emailController.dispose();
    professionController.dispose();
    phoneController.dispose();
    passwordController.dispose();

    birthDayController.dispose();
    birthMonthController.dispose();
    birthYearController.dispose();

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
    passwordController.clear();
    birthDayController.clear();
    birthMonthController.clear();
    birthYearController.clear();

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
                            color: theme.colorScheme.surface,
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
                              color: theme.colorScheme.surface,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

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

                          const SizedBox(height: 20),

                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  controller: nameController,
                                  label: "Nome completo",
                                  hintText: "Seu nome aqui",
                                  size: 724,
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
                                  size: 600,
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
                            hintText: "exemplo@outlook.com",
                            size: 724,
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
                                  size: 724,
                                  validator: Validators.required,
                                  prefixIcon: const Icon(Icons.work_outline),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: CustomTextField(
                                  controller: phoneController,
                                  label: "Telefone",
                                  size: 200,
                                  hintText: "(dd) 0 0000 0000",
                                  keyboardType: TextInputType.phone,
                                  validator: Validators.phone,
                                  prefixIcon: const Icon(Icons.phone_outlined),
                                ),
                              ),
                            ],
                          ),

                          _gap(),

                          // ===== Data de nascimento (manual: Dia/Mês/Ano)
                          Text(
                            "Data de nascimento :",
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.tertiary,
                                ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 100,
                                child: CustomTextField(
                                  controller: birthDayController,
                                  label: "",
                                  hintText: "Dia",
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(2),
                                  ],
                                  validator: (v) {
                                    final d = int.tryParse(v ?? "");
                                    if (d == null) return "Inválido";
                                    if (d < 1 || d > 31) return "1-31";
                                    return null;
                                  },
                                  prefixIcon: const Icon(
                                    Icons.calendar_today_outlined,
                                    size: 20,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 10),
                              SizedBox(
                                width: 100,
                                child: CustomTextField(
                                  controller: birthMonthController,
                                  label: "",
                                  hintText: "Mês",
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(2),
                                  ],
                                  validator: (v) {
                                    final m = int.tryParse(v ?? "");
                                    if (m == null) return "Inválido";
                                    if (m < 1 || m > 12) return "1-12";
                                    return null;
                                  },
                                ),
                              ),

                              const SizedBox(width: 10),
                              SizedBox(
                                width: 150,
                                child: CustomTextField(
                                  controller: birthYearController,
                                  label: "",
                                  hintText: "Ano",
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(4),
                                  ],
                                  validator: (v) {
                                    final y = int.tryParse(v ?? "");
                                    final nowY = DateTime.now().year;
                                    if (y == null) return "Inválido";
                                    if (y < 1900 || y > nowY)
                                      return "1900-$nowY";
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),

                          // ===== Senha
                          CustomTextField(
                            controller: passwordController,
                            label: "Senha",
                            hintText: "********",
                            size: 270,
                            obscureText: !_showPassword,
                            validator: (v) => Validators.minLength(
                              v,
                              6,
                              message: "Senha deve ter no mínimo 6 caracteres",
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

                          const SizedBox(height: 14),

                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  controller: cepController,
                                  label: "CEP",
                                  hintText: "00000-000",
                                  size: 500,
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
                                  size: 500,
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
                                  size: 500,
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
                                  size: 500,
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
                            size: 500,
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
                                  size: 500,
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
                                  size: 500,
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
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white, // Fundo branco
                              foregroundColor: theme
                                  .colorScheme
                                  .primary, // Texto e ícone azul )
                              elevation:
                                  5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: registerController.isLoading.value
                                ? SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: theme
                                  .colorScheme
                                  .primary,
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
                                          birthDate:
                                              "${birthYearController.text}-"
                                              "${birthMonthController.text.padLeft(2, '0')}-"
                                              "${birthDayController.text.padLeft(2, '0')}",
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
                                color: theme.colorScheme.primary,
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
