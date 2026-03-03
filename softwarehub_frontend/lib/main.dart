import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'infra/datasources/auth_local_datasource.dart';
import 'infra/datasources/auth_remote_datasource.dart';
import 'infra/repositories/auth_repository_impl.dart';
import 'presentation/core/my_widget.dart';
import 'presentation/shared/controller/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);

  final local = AuthLocalDataSource();
  final remote = AuthRemoteDataSource(http.Client());
  final repository = AuthRepositoryImpl(remote, local);

  final authController = Get.put<AuthController>(
    AuthController(repository),
    permanent: true,
  );

  await authController.loadSession();

  runApp(
    MyWidget(
      initialRoute: authController.isAuthenticated
          ? '/home'
          : '/',
    ),
  );
}


