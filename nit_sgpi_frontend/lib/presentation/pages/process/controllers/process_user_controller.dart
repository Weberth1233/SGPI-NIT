import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/domain/entities/user/user_entity.dart';
import 'package:nit_sgpi_frontend/domain/usecases/get_users.dart';

class ProcessUserController extends GetxController {
  final GetUsers getUsers;
  ProcessUserController(this.getUsers);

  // ✅ Observables: Usamos um mapa de <ID, UserEntity> para eliminar o cache da View.
  final RxMap<int, UserEntity> selectedUsers = <int, UserEntity>{}.obs;
  
  final RxBool isLoading = false.obs;
  final RxList<UserEntity> users = <UserEntity>[].obs;
  final RxString errorMessage = ''.obs;
  
  // Filtros e Paginação
  final RxString fullNameFilter = ''.obs;
  final RxInt page = 0.obs;
  final int size = 9;
  final RxBool hasMore = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  // ✅ Adiciona ou remove recebendo a entidade inteira
  void toggleUser(UserEntity user) {
    if (user.id == null) return;
    
    if (selectedUsers.containsKey(user.id)) {
      selectedUsers.remove(user.id);
    } else {
      selectedUsers[user.id!] = user;
    }
  }

  // ✅ Método de conveniência para remover do painel lateral apenas pelo ID
  void removeUserById(int id) {
    selectedUsers.remove(id);
  }

  void searchByFullName(String query) {
    fullNameFilter.value = query;
    fetchUsers(loadMore: false);
  }

  Future<void> fetchUsers({bool loadMore = false}) async {
    if (isLoading.value || (loadMore && !hasMore.value)) return;

    isLoading.value = true;
    errorMessage.value = '';

    if (loadMore) {
      page.value++;
    } else {
      page.value = 0;
      users.clear();
      hasMore.value = true;
    }

    final result = await getUsers(
      fullName: fullNameFilter.value,
      page: page.value,
      size: size,
    );

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        // ✅ Blindagem contra página negativa
        if (loadMore && page.value > 0) page.value--;
      },
      (pagedResult) {
        users.assignAll(pagedResult.content);
        hasMore.value = pagedResult.content.length >= size;
      },
    );

    isLoading.value = false;
  }

Future<void> fetchPreviousPage() async {
    // Se está carregando ou já está na primeira página (0), não faz nada
    if (isLoading.value || page.value == 0) return;

    isLoading.value = true;
    errorMessage.value = '';
    
    page.value--; // Volta o contador da página

    final result = await getUsers(
      fullName: fullNameFilter.value,
      page: page.value,
      size: size,
    );

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        page.value++; // Desfaz a volta se der erro na conexão
      },
      (pagedResult) {
        users.assignAll(pagedResult.content); // Substitui pelos itens antigos
        hasMore.value = true; // Se conseguimos voltar, sabemos que há páginas para frente
      },
    );

    isLoading.value = false;
  }

}