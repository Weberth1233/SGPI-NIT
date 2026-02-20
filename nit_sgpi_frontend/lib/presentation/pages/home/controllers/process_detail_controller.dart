import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/domain/usecases/get_process_by_id.dart';
import '../../../../domain/core/errors/failures.dart';
import '../../../../domain/entities/process/process_response_entity.dart';
import '../../../../infra/datasources/auth_local_datasource.dart';

class ProcessDetailController extends GetxController {
  final GetProcessById _getProcessById;
  final AuthLocalDataSource _authLocal;

  ProcessDetailController(this._getProcessById, this._authLocal);

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  
  final Rxn<ProcessResponseEntity> process = Rxn<ProcessResponseEntity>();

  final RxString userRole = ''.obs;

  bool get isAdmin => userRole.value == 'ADMIN';

  @override
  void onInit() {
    super.onInit();   
    _checkRole();
    _loadProcessId();
  }

  Future<void> _checkRole() async {
    final role = await _authLocal.getRole();
    if (role != null) {
      userRole.value = role;
    }
  }

  void _loadProcessId() {
    String? idStr = Get.parameters['id']; 
    var argId = Get.arguments;           

    int? finalId;

    if (idStr != null && idStr.isNotEmpty) {
      finalId = int.tryParse(idStr);
    } else if (argId != null && argId is int) {
      finalId = argId;
    }

    if (finalId != null) {
      fetchProcess(finalId);
    } else {
      errorMessage.value = "ID do processo não encontrado.";
      Get.snackbar(
        "Erro", 
        "Não foi possível identificar o ID do processo.",
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }

  Future<void> fetchProcess(int id) async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await _getProcessById(id);

    result.fold(
      (Failure failure) {
        // Falha
        isLoading.value = false;
        errorMessage.value = failure.message;
        process.value = null; 

        Get.snackbar(
          "Erro", 
          "Falha ao carregar processo: ${failure.message}",
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      (ProcessResponseEntity success) {
        // Sucesso
        isLoading.value = false;
        process.value = success;
      },
    );
  }
}