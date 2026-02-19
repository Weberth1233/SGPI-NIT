import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nit_sgpi_frontend/domain/repositories/iattachment_repository.dart';
import 'package:nit_sgpi_frontend/domain/usecases/get_attachments.dart';
import 'package:nit_sgpi_frontend/domain/usecases/open_attachment.dart';
import 'package:nit_sgpi_frontend/domain/usecases/upload_file.dart';
import 'package:nit_sgpi_frontend/infra/datasources/attachment_datasource.dart';
import 'package:nit_sgpi_frontend/infra/repositories/attachment_repository_impl.dart';
import 'package:nit_sgpi_frontend/presentation/pages/attachments/controllers/attachments_controller.dart';

import '../../../../infra/core/network/api_client.dart';
import '../../../../infra/datasources/auth_local_datasource.dart';

class AttachmentsBindigs extends Bindings{

  @override
  void dependencies() {
      // Http client puro
    Get.lazyPut<http.Client>(() => http.Client());
    // Local datasource (token)
    Get.lazyPut<AuthLocalDataSource>(() => AuthLocalDataSource());
    // ApiClient (usa http.Client + AuthLocalDataSource)
    Get.lazyPut<ApiClient>(
      () => ApiClient(
        Get.find<http.Client>(),
        Get.find<AuthLocalDataSource>(),
      ),
    );
  Get.lazyPut<IAttachmentDatasource>(
      () => AttachmentDataSourceImpl(Get.find<ApiClient>()),
    );
     // Repository
    Get.lazyPut<IAttachmentRepository>(
      () => AttachmentRepositoryImpl(remoteDataSource: Get.find<IAttachmentDatasource>()),
    );
    // UseCase
    Get.lazyPut<OpenAttachmentUseCase>(
      () => OpenAttachmentUseCase(Get.find<IAttachmentRepository>()),
    );
    Get.lazyPut<GetAttachments>(
      () => GetAttachments(Get.find<IAttachmentRepository>()),
    );
    Get.lazyPut<UploadFile>(
      () => UploadFile(Get.find<IAttachmentRepository>()),
    );

    Get.lazyPut<AttachmentController>(
      () => AttachmentController(Get.find<OpenAttachmentUseCase>(), Get.find<GetAttachments>(), Get.find<UploadFile>()),
    );
    
  }
}