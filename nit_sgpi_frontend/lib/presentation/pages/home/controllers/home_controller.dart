import 'package:get/get.dart';
import 'package:dartz/dartz.dart';

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

  // Paginação (opcional)
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
}
