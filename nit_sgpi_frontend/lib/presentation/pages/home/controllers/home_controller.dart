import 'package:get/get.dart';

import '../../../../domain/core/errors/failures.dart';
import '../../../../domain/entities/process/process_entity.dart';
import '../../../../domain/usecases/get_process.dart';

class ProcessController extends GetxController {
  final GetProcesses getProcesses;

  ProcessController(this.getProcesses);

  // Observables
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<ProcessEntity> processes = <ProcessEntity>[].obs;

  final RxString title = ''.obs;
  final RxString status = ''.obs; // 👈 novo filtro de status

  // Paginação
  final RxInt page = 0.obs;
  final int size = 10;

  @override
  void onInit() {
    super.onInit();
    fetchProcesses();
  }

  Future<void> fetchProcesses({bool loadMore = false}) async {
    if (isLoading.value) return;

    isLoading.value = true;
    errorMessage.value = '';

    if (loadMore) {
      page.value++;
    } else {
      page.value = 0;
      processes.clear();
    }

    final result = await getProcesses(
      title: title.value,
      statusGenero: status.value, // 👈 agora manda o status também
      page: page.value,
      size: size,
    );

    result.fold(
      (Failure failure) {
        errorMessage.value = failure.message;
        if (loadMore) {
          page.value--; // rollback da página se deu erro
        }
      },
      (pagedResult) {
        processes.addAll(pagedResult.content);
      },
    );

    isLoading.value = false;
  }

  /// 🔍 Chamar quando apertar ENTER na busca
  void searchByTitle(String value) {
    title.value = value;
    fetchProcesses(loadMore: false); // reseta a lista e busca de novo
  }

  /// 🏷️ Chamar quando clicar em um filtro de status
  void filterByStatus(String newStatus) {
    status.value = newStatus; // ex: "EM_ANDAMENTO" ou ""
    fetchProcesses(loadMore: false); // reseta e busca de novo
  }
}
