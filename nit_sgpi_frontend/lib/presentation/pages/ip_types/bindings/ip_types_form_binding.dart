import 'package:get/get.dart';

import '../../../../domain/entities/ip_types/ip_type_entity.dart';
import '../controllers/Ip_types_form_controller.dart';

class IpTypesFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IpTypesFormController>(() {
      final ipType = Get.arguments as IpTypeEntity;
      return IpTypesFormController(ipType);
    });
  }
}
