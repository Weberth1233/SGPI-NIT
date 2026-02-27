import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/domain/usecases/forgot_password.dart';

import '../../../../../domain/core/errors/failures.dart';

class ForgotPasswordController extends GetxController {
  final ForgotPassword _forgotPassword;

  ForgotPasswordController(this._forgotPassword);

  RxBool loading = false.obs;
  RxString message = "".obs;

  Future<void> forgotPassword(String email) async {
    loading.value = true;
    message.value = "";

    final result = await _forgotPassword(email);
    result.fold(
      (Failure failure) {
        message.value = failure.message;
        Get.snackbar(
            "Erro",
            message.value,
            backgroundColor: Get.theme.colorScheme.error,
            colorText: Get.theme.colorScheme.onError,
            snackPosition: SnackPosition.TOP,
          );
      },
      (result) {
        message.value = result;
        Get.snackbar(
            "Sucesso",
            message.value,
            backgroundColor: Get.theme.colorScheme.primary,
            colorText: Get.theme.colorScheme.onPrimary,
            snackPosition: SnackPosition.TOP,
          );
      },
    );

    loading.value = false;
  }
}
