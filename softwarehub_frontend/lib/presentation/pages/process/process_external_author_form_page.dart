import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/domain/entities/external_author/external_author_entity.dart';

import '../../shared/utils/responsive.dart';
import '../../shared/utils/validators.dart';
import '../../shared/widgets/custom_text_field.dart';
import 'controllers/process_external_author_controller.dart';

class ProcessExternalAuthorFormPage extends StatefulWidget {
  const ProcessExternalAuthorFormPage({super.key});

  @override
  State<ProcessExternalAuthorFormPage> createState() =>
      _ProcessExternalAuthorFormPageState();
}

class _ProcessExternalAuthorFormPageState
    extends State<ProcessExternalAuthorFormPage> {
  final controller = Get.find<ProcessExternalAuthorController>();
  final _formKey = GlobalKey<FormState>();

  // Tenta recuperar a entidade para edição vinda dos argumentos
  final ExternalAuthorEntity? editingEntity = Get.arguments as ExternalAuthorEntity?;

  late final TextEditingController fullNameController;
  late final TextEditingController emailController;
  late final TextEditingController cpfController;

  @override
  void initState() {
    super.initState();
    // Se editingEntity não for nulo, estamos em modo de EDIÇÃO
    fullNameController = TextEditingController(text: editingEntity?.fullName);
    emailController = TextEditingController(text: editingEntity?.email);
    cpfController = TextEditingController(text: editingEntity?.cpf);
  }

  // Atalho para saber se é edição
  bool get isEditing => editingEntity != null;

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    cpfController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final entity = ExternalAuthorEntity(
        id: editingEntity?.id, // Importante: mantém o ID na edição
        fullName: fullNameController.text.trim(),
        email: emailController.text.trim(),
        cpf: cpfController.text.replaceAll(RegExp(r'[^0-9]'), ''),
      );

      // Decide qual método do controller chamar
      final bool isSuccess = isEditing 
          ? await controller.updateExternalAuthor(entity.id!, entity) // Você precisa criar esse método no controller
          : await controller.postExternalAuthor(entity);

      if (isSuccess) {
        Get.snackbar(
          "Sucesso",
          isEditing ? "Cadastro atualizado!" : "Cadastro realizado!",
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
        );

        // Fluxo: Se editou, volta. Se cadastrou, limpa (ou volta se preferir)
        if (!isEditing) {
          clear();
        }
      } else {
        Get.snackbar(
          "Erro",
          controller.errorMessage.value,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
        );
      }
    }
  }

  void clear() {
    fullNameController.clear();
    emailController.clear();
    cpfController.clear();
    _formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: _buildAppBar(colors, theme),
      body: Stack(
        children: [
          _buildBackground(colors),
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.getPadding(context).left,
              vertical: 32,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: _buildFormCard(colors, theme),
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(ColorScheme colors, ThemeData theme) {
    return AppBar(
      elevation: 0,
      backgroundColor: colors.primary,
      automaticallyImplyLeading: false,
      toolbarHeight: 80,
      title: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            style: IconButton.styleFrom(
              backgroundColor: colors.onPrimary.withOpacity(0.2),
              foregroundColor: colors.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            isEditing ? "Editar Autor Externo" : "Cadastrar Autor Externo",
            style: theme.textTheme.titleLarge?.copyWith(
              color: colors.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground(ColorScheme colors) {
    // Mantendo seu painter customizado
    return const SizedBox.shrink(); 
    // Se o DiagonalLinesPainter estiver em outro arquivo, mantenha o CustomPaint aqui
  }

  Widget _buildFormCard(ColorScheme colors, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEditing ? "Alterar Dados do Autor" : "Informações Pessoais", 
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 24),
            CustomTextField(
              controller: fullNameController,
              label: "Nome completo",
              validator: Validators.required,
              prefixIcon: const Icon(Icons.person_outline),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: CustomTextField(
                    controller: emailController,
                    label: "E-mail",
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
                    prefixIcon: const Icon(Icons.alternate_email),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: CustomTextField(
                    controller: cpfController,
                    label: "CPF",
                    hintText: "000.000.000-00",
                    keyboardType: TextInputType.number,
                    validator: Validators.cpf,
                    prefixIcon: const Icon(Icons.badge_outlined),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : Text(
                          isEditing ? 'Salvar Alterações' : 'Salvar Cadastro',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}