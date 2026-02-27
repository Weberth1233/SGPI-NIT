import 'package:get/get_navigation/get_navigation.dart';
import 'package:nit_sgpi_frontend/presentation/pages/attachments/attachments_page.dart';
import 'package:nit_sgpi_frontend/presentation/pages/attachments/bindings/attachments_bindigs.dart';
import 'package:nit_sgpi_frontend/presentation/pages/auth/password_reset/forgot_password_page.dart';
import 'package:nit_sgpi_frontend/presentation/pages/home/bindings/process_detail_bindings.dart';
import 'package:nit_sgpi_frontend/presentation/pages/home/process_detail_page.dart';
import 'package:nit_sgpi_frontend/presentation/pages/ip_types/bindings/ip_types_bindings.dart';
import 'package:nit_sgpi_frontend/presentation/pages/ip_types/ip_types_page.dart';
import 'package:nit_sgpi_frontend/presentation/pages/justifications/bindings/justification_bindings.dart';
import 'package:nit_sgpi_frontend/presentation/pages/justifications/justification_page.dart';
import 'package:nit_sgpi_frontend/presentation/pages/auth/login/login_page.dart';
import 'package:nit_sgpi_frontend/presentation/pages/process/bindings/user_bindings.dart';
import 'package:nit_sgpi_frontend/presentation/pages/process/process_page.dart';
import 'package:nit_sgpi_frontend/presentation/pages/auth/register/bindings/register_bindings.dart';
import 'package:nit_sgpi_frontend/presentation/pages/auth/register/register_page.dart';
import '../../pages/home/bindings/home_bindings.dart';
import '../../pages/home/home_page.dart';
import '../../pages/ip_types/bindings/ip_types_form_binding.dart';
import '../../pages/ip_types/ip_types_form.dart';
import '../../pages/auth/login/bindings/login_bindings.dart';

class MyRoutes {
  static String get initialRoute => '/';

  static List<GetPage> get pages => [
    GetPage(name: '/', page: () => LoginPage(), binding: LoginBindings()),
    GetPage(
      name: "/register",
      page: () => RegisterPage(),
      binding: RegisterBindings(),
    ),

    GetPage(name: "/forgot-password", page:() => ForgotPasswordPage()),

    GetPage(name: "/home", page: () => HomePage(), binding: HomeBindings()),
    
    GetPage(name: "/user-logged", page: () => RegisterPage(isEditMode: true,), binding: RegisterBindings()),

    GetPage(name: "/process", page: () => ProcessPage(), binding: UserBindings()),

    
    GetPage(name: "/process-edit", page: () => ProcessPage(isEditMode: true,), binding: UserBindings()),
    

    GetPage(name: "/home/process-detail/:id", page:() =>  ProcessDetailPage(), binding: ProcessDetailBindings()),
    
    GetPage(name: "/process-detail/attachments", page:() => AttachmentsPage(), binding: AttachmentsBindigs()),

    GetPage(name: "/process-detail/justification", page:() => JustificationPage(), binding: JustificationBindings()),

    


    GetPage(
      name: '/process/ip_types',
      page: () => IpTypesPage(),
      binding: IpTypesBindings(),
    ),

    GetPage(
      name: '/process/ip_types/form',
      page: () => IpTypesForm(),
      binding: IpTypesFormBinding(),
    ),
  ];
}
