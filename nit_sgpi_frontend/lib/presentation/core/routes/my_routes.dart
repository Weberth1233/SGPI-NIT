import 'package:get/get_navigation/get_navigation.dart';
import 'package:nit_sgpi_frontend/presentation/pages/home/home_PAGE.dart';
import 'package:nit_sgpi_frontend/presentation/pages/login/login_page.dart';

class MyRoutes {
  static String get initialRoute => '/';

static List<GetPage> get pages =>[
  GetPage(name: '/', page: ()=> LoginPage()),
  GetPage(name: "/home", page: () => HomePage())
];
}