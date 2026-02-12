import '../core/network/api_client.dart';
import '../core/network/base_url.dart';

abstract class IAttachmentDatasource{
  Future<void> getDocument(int id);
}

class IAttachmentDataSourceImpl implements IAttachmentDatasource{
   final ApiClient apiClient;

  IAttachmentDataSourceImpl(this.apiClient);
  

  @override
  Future<void> getDocument(int id) async{
    try{
      final response = await apiClient.get(
        "${BaseUrl.urlWithHttp}/attachments/download/template/$id",
      );
    }catch(e){

    }
  }
   
 

}