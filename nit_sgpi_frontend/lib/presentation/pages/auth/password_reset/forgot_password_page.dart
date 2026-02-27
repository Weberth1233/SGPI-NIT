import 'package:flutter/material.dart';
import 'package:nit_sgpi_frontend/presentation/shared/widgets/custom_text_field.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    
    TextEditingController email = TextEditingController();
    
    return Scaffold(
      body: Center(
        child: Card(
          child: Column(children: [
            Text("Digite seu email cadastrado no sistema!"),
            CustomTextField(controller: email, label: "E-mail"),
            ElevatedButton(onPressed: (){}, child: Text("Enviar"))
          ],),
        ),
      ),
    );
  }
}