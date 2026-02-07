import 'package:get/get_navigation/get_navigation.dart';
import 'package:nit_sgpi_frontend/presentation/pages/login/login_page.dart';
import '../../pages/home/bindings/home_bindings.dart';
import '../../pages/home/home_page.dart';
import '../../pages/login/bindings/login_bindings.dart';

class MyRoutes {
  static String get initialRoute => '/';

static List<GetPage> get pages =>[
  GetPage(name: '/', page: ()=> LoginPage(), binding: LoginBindings()),
  GetPage(name: "/home", page: () => HomePage(), binding: HomeBindings())
];
}