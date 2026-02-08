import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/domain/entities/process/process_status_count_entity.dart';
import 'package:nit_sgpi_frontend/domain/usecases/get_process_status_count.dart';

import '../../../../domain/core/errors/failures.dart';
import '../../../../domain/entities/process/process_entity.dart';
import '../../../../domain/usecases/get_process.dart';

class ProcessController extends GetxController {
  final GetProcesses getProcesses;
  final GetProcessStatusCount getProcessStatusCount;

  ProcessController(this.getProcesses, this.getProcessStatusCount);

  // Observables
  final RxBool isLoading = false.obs;
  final RxBool isLoadingProcessCount = false.obs;

  final RxString errorMessage = ''.obs;
  final RxList<ProcessEntity> processes = <ProcessEntity>[].obs;

  final RxList<ProcessStatusCountEntity> processesStatus =
      <ProcessStatusCountEntity>[].obs;

  final RxString title = ''.obs;
  final RxString status = ''.obs; // 👈 novo filtro de status

  // Paginação
  final RxInt page = 0.obs;
  final int size = 10;

  @override
  void onInit() {
    super.onInit();
    fetchProcesses();
    processStatusCount();
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

  void searchByTitle(String value) {
    title.value = value;
    fetchProcesses(loadMore: false);
  }

  void filterByStatus(String newStatus) {
    status.value = newStatus;
    fetchProcesses(loadMore: false);
  }

  Future<void> processStatusCount() async {
    if (isLoadingProcessCount.value) return;

    isLoadingProcessCount.value = true;

    final result = await getProcessStatusCount();

    result.fold(
      (Failure failure) {
        errorMessage.value = failure.message;
      },
      (list) {
        processesStatus.assignAll(list);
      },
    );

    isLoadingProcessCount.value = false;
  }
}
