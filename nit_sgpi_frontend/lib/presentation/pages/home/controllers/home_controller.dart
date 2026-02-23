import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/domain/entities/process/process_status_count_entity.dart';
import 'package:nit_sgpi_frontend/domain/usecases/delete_process.dart';
import 'package:nit_sgpi_frontend/domain/usecases/get_process_status_count.dart';
import '../../../../domain/core/errors/failures.dart';
import '../../../../domain/entities/process/process_response_entity.dart';
import '../../../../domain/usecases/get_process.dart';

class ProcessController extends GetxController {
  final GetProcesses getProcesses;
  final GetProcessStatusCount getProcessStatusCount;
  final DeleteProcess deleteProcess;

  ProcessController(
    this.getProcesses,
    this.getProcessStatusCount,
    this.deleteProcess,
  );

  // ===================== STATES =====================

  final RxBool isLoadingList = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool isDeleting = false.obs;
  final RxBool isLoadingProcessCount = false.obs;

  final RxString errorMessage = ''.obs;

  final RxList<ProcessResponseEntity> processes = <ProcessResponseEntity>[].obs;

  final RxList<ProcessStatusCountEntity> processesStatus =
      <ProcessStatusCountEntity>[].obs;

  final RxString title = ''.obs;
  final RxString status = ''.obs;

  final RxInt page = 0.obs;
  final int size = 10;

  // ===================== INIT =====================

  @override
  void onInit() {
    super.onInit();
    fetchProcesses();
    processStatusCount();
  }

  // ===================== FETCH =====================

  Future<void> fetchProcesses({bool loadMore = false}) async {
    if (loadMore) {
      if (isLoadingMore.value) return;
      isLoadingMore.value = true;
      page.value++;
    } else {
      if (isLoadingList.value) return;
      isLoadingList.value = true;
      page.value = 0;
      processes.clear();
    }

    final result = await getProcesses(
      title: title.value,
      statusGenero: status.value,
      page: page.value,
      size: size,
    );

    result.fold(
      (Failure failure) {
        errorMessage.value = failure.message;
        if (loadMore) page.value--;
      },
      (pagedResult) {
        processes.addAll(pagedResult.content);
      },
    );

    if (loadMore) {
      isLoadingMore.value = false;
    } else {
      isLoadingList.value = false;
    }
  }

  void searchByTitle(String value) {
    title.value = value;
    fetchProcesses();
  }

  void filterByStatus(String newStatus) {
    status.value = newStatus;
    fetchProcesses();
  }

  // ===================== STATUS COUNT =====================

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

  Future<void> deleteProcessById(int id) async {
    if (isDeleting.value) return;

    isDeleting.value = true;

    final result = await deleteProcess(id);

    await result.fold(
      (Failure failure) async {
        Get.snackbar("Erro", failure.message);
      },
      (message) async {
        // 🔥 RESET COMPLETO DA LISTA
        page.value = 0;
        processes.clear();

        // 🔥 BUSCA DO ZERO
        await fetchProcesses(loadMore: false);

        // 🔥 ATUALIZA OS CARDS DE STATUS
        await processStatusCount();

        Get.snackbar("Sucesso", message);
      },
    );

    isDeleting.value = false;
  }
}
