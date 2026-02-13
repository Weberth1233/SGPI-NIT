import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/domain/entities/attachment_entity.dart';
import 'package:nit_sgpi_frontend/domain/usecases/get_attachments.dart';

import '../../../../domain/core/errors/failures.dart';
import '../../../../domain/usecases/open_attachment.dart';

class AttachmentController extends GetxController {
  final GetAttachments getAttachments;
  final OpenAttachmentUseCase openAttachment;

  AttachmentController(this.openAttachment, this.getAttachments);

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<AttachmentEntity> attachmentList = <AttachmentEntity>[].obs;

  Future<void> open(int id) async {
    try {
      await openAttachment(id);
    } catch (e) {
      Get.snackbar("Erro", "Não foi possível abrir o documento");
    }
  }

  Future<void> attachments(int idProcess) async {
    if (isLoading.value) return;

    isLoading.value = true;

    final result = await getAttachments(idProcess);

    result.fold(
      (Failure failure) {
        errorMessage.value = failure.message;
      },
      (list) {
        attachmentList.assignAll(list);
      },
    );
    isLoading.value = false;
  }

  

}
