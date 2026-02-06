import 'package:flutter/material.dart';
import 'package:http/http.dart' as http show Client;
import 'package:nit_sgpi_frontend/domain/usecases/login_usecase.dart';
import 'package:nit_sgpi_frontend/infra/repositories/auth_repository_impl.dart' show AuthRepositoryImpl;
import 'package:nit_sgpi_frontend/presentation/core/my_widget.dart';
import 'package:nit_sgpi_frontend/presentation/pages/login/login_page.dart';

import 'infra/datasources/auth_local_datasource.dart';
import 'infra/datasources/auth_remote_datasource.dart';
import 'presentation/pages/login/controllers/login_controller.dart';

late LoginController loginController;
void main() {
  final remote = AuthRemoteDataSource(http.Client());
  final local = AuthLocalDataSource();
  final repo = AuthRepositoryImpl(remote, local);
  final loginUseCase = LoginUsecase(repository: repo);

  loginController = LoginController(loginUseCase);
  
  runApp(const MyWidget());
}


