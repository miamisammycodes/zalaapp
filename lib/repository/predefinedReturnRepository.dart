import 'package:eshop/Helper/ApiBaseHelper.dart';
import 'package:eshop/Helper/Constant.dart';
import 'package:eshop/Helper/String.dart';
import 'package:eshop/Model/predefiendReasonsModel.dart';
import 'package:eshop/ui/widgets/ApiException.dart';

class PredefinedReturnRepository {
  Future<List<PredefiendReasonsModel>> getPredefinedReturnRepository(
      {required Map<String, dynamic> parameter}) async {
    try {
      // ✅ Print the parameters before making the API request
      print("📤 API Request Parameters: $parameter");

      final responseData =
          await ApiBaseHelper().postAPICall(getPredefiendReasons, parameter);
      
      // ✅ Print the API response
      print("✅ API Response: $responseData");

      return responseData['data']
          .map<PredefiendReasonsModel>(
              (e) => PredefiendReasonsModel.fromJson(e))
          .toList();
    } on Exception catch (e, st) {
      print("❌ Error in Get predefineReasons:- $st");
      throw ApiException('$errorMesaage$e');
    }
  }
}
