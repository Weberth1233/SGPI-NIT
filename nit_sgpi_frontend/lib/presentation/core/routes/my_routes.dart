import 'package:get/get_navigation/get_navigation.dart';
import 'package:nit_sgpi_frontend/presentation/pages/ip_types/bindings/ip_types_bindings.dart';
import 'package:nit_sgpi_frontend/presentation/pages/ip_types/ip_types_page.dart';
import 'package:nit_sgpi_frontend/presentation/pages/login/login_page.dart';
import 'package:nit_sgpi_frontend/presentation/pages/process/bindings/user_bindings.dart';
import 'package:nit_sgpi_frontend/presentation/pages/process/process_page.dart';
import 'package:nit_sgpi_frontend/presentation/pages/register/bindings/register_bindings.dart';
import 'package:nit_sgpi_frontend/presentation/pages/register/register_page.dart';
import '../../pages/home/bindings/home_bindings.dart';
import '../../pages/home/home_page.dart';
import '../../pages/ip_types/bindings/ip_types_form_binding.dart';
import '../../pages/ip_types/ip_types_form.dart';
import '../../pages/login/bindings/login_bindings.dart';

class MyRoutes {
  static String get initialRoute => '/';

  static List<GetPage> get pages => [
    GetPage(name: '/', page: () => LoginPage(), binding: LoginBindings()),
    GetPage(
      name: "/register",
      page: () => RegisterPage(),
      binding: RegisterBindings(),
    ),
    GetPage(name: "/home", page: () => HomePage(), binding: HomeBindings()),
    GetPage(name: "/process", page: () => ProcessPage(), binding: UserBindings()),
    
    GetPage(
      name: '/home/ip_types',
      page: () => IpTypesPage(),
      binding: IpTypesBindings(),
    ),

    GetPage(
      name: '/home/ip_types/form',
      page: () => IpTypesForm(),
      binding: IpTypesFormBinding(),
    ),
  ];
}
