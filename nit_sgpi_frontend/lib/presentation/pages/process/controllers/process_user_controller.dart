import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/domain/entities/user/user_entity.dart';
import 'package:nit_sgpi_frontend/domain/usecases/get_users.dart';

import '../../../../domain/core/errors/failures.dart';

class ProcessUserController extends GetxController {
  final GetUsers getUsers;

  ProcessUserController( this.getUsers);
   var selectedUserIds = <int>{}.obs;

  // Observables
  final RxBool isLoading = false.obs;
  final RxBool isLoadingProcessCount = false.obs;

  final RxString errorMessage = ''.obs;
  final RxList<UserEntity> users = <UserEntity>[].obs;

  final RxString userName = ''.obs;
  final RxString fullName = ''.obs; // 👈 novo filtro de status

  // Paginação
  final RxInt page = 0.obs;
  final int size = 10;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers({bool loadMore = false}) async {
    if (isLoading.value) return;

    isLoading.value = true;
    errorMessage.value = '';

    if (loadMore) {
      page.value++;
    } else {
      page.value = 0;
      users.clear();
    }

    final result = await getUsers(
      fullName: fullName.value,
      userName: userName.value, // 👈 agora manda o status também
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
        users.addAll(pagedResult.content);
      },
    );

    isLoading.value = false;
  }

   void toggleUser(int userId) {
    if (selectedUserIds.contains(userId)) {
      selectedUserIds.remove(userId);
    } else {
      selectedUserIds.add(userId);
    }
  }

  void searchByFullName(String value) {
    fullName.value = value;
    fetchUsers(loadMore: false);
  }

  void filterByUserName(String value) {
    userName.value = value;
    fetchUsers(loadMore: false);
  }
}
