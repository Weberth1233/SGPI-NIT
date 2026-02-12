import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/domain/entities/attachment_entity.dart';
import 'package:nit_sgpi_frontend/presentation/shared/utils/responsive.dart';
import 'package:nit_sgpi_frontend/presentation/shared/widgets/custom_menu.dart';
import 'package:url_launcher/url_launcher.dart' show launchUrl;

class AttachmentsPage extends StatelessWidget {
  const AttachmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final attachments = Get.arguments as AttachmentEntity;

    Future<void> openDocumentWeb() async {
      final uri = Uri.parse(
        'http://localhost:8080/attachments/download/template/${attachments.id}',
      );

      if (!await launchUrl(uri, webOnlyWindowName: '_blank')) {
        throw 'Não foi possível abrir o documento';
      }
    }

    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      body: CustomMenu(
        child: Container(
          margin: Responsive.getPadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                "Documentos para assinatura",
                style: textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Passo 1: Baixe os modelos, assine e salve no seu computador.",
              ),
              SizedBox(height: 50),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          attachments.displayName,
                          style: textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text("Obrigatório: Assinatura por todos os autores"),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      openDocumentWeb();
                    },
                    child: Text(
                      "Baixar modelo",
                      style: textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
