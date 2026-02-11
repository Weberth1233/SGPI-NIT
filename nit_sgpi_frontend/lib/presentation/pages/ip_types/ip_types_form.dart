import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/presentation/shared/utils/responsive.dart';
import 'package:nit_sgpi_frontend/presentation/shared/widgets/custom_text_field.dart';

import 'controllers/Ip_types_form_controller.dart';

class IpTypesForm extends GetView<IpTypesFormController> {
  const IpTypesForm({super.key});

  @override
  Widget build(BuildContext context) {
    final ipType = controller.ipType;
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
     backgroundColor: theme.onSecondary,
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: Responsive.getPadding(context),
          child: SingleChildScrollView(
            child: Column(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                                Get.back();
                              },
                              icon: const Icon(Icons.arrow_back, size: 30),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              ipType.name,
                              style: Theme.of(context).textTheme.headlineSmall!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
            
                ...ipType.formStructure.fields.map((field) {
                  final textController = controller.controllers[field.name]!;
            
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: CustomTextField(
                      controller: textController,
                      keyboardType: field.type == 'number'
                          ? TextInputType.number
                          : TextInputType.text, label: field.name,
                      
                    ),
                  );
                }).toList(),
            
                const SizedBox(height: 24),
            
                SizedBox(
                
                  child: ElevatedButton(
                    onPressed: controller.submit,
                    child:  Text('Enviar', style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.onSecondary),),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
