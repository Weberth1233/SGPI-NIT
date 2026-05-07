import 'package:get/get.dart';
import '../../../../../domain/core/errors/failures.dart';
import '../../../../../domain/entities/address_api_entity.dart';
import '../../../../../domain/entities/user/user_entity.dart';
import '../../../../../domain/usecases/get_by_zipcode.dart';
import '../../../../../domain/usecases/post_user.dart';
import '../../../../../domain/usecases/put_user.dart';

class RegisterController extends GetxController{
  final PostUser _postUser;
  final PutUser _putUser;
  final GetByZipcode _getByZipcode;

  RegisterController(this._postUser, this._putUser,this._getByZipcode);
  RxBool isLoading = false.obs;
  RxString message = "".obs;
  var addressApiEntity = Rxn<AddressApiEntity>();

  Future<void> post(UserEntity user) async {
    if (isLoading.value) return;
    isLoading.value = true;
    message.value = '';
    final result = await _postUser(
      user
    );
    result.fold(
      (Failure failure) {
        
        message.value = failure.message;
      },
      (sucess) {
        message.value = sucess;
      },
    );
    isLoading.value = false;
  }

  Future<void> updateUserLogged(int idUser, UserEntity user) async {
    isLoading.value = true;
    message.value = "";

    final result = await _putUser(idUser, user);

    result.fold(
      (failure) {
        message.value = failure.message;
      },
      (sucess) {
        message.value = sucess;
        

      },  
    );

    isLoading.value = false;
  }

   Future<AddressApiEntity?> getByZipCode(String cep) async {
  try {
    isLoading.value = true;

    final result = await _getByZipcode(cep);

    return result.fold(
      (failure) {
        Get.snackbar(
          "Erro",
          "Não foi possível buscar o CEP",
        );
        return null;
      },
      (address) {
        return address;
      },
    );
  } finally {
    isLoading.value = false;
  }
}
}