import 'package:eshop/Helper/ApiBaseHelper.dart';
import 'package:eshop/Helper/Constant.dart';
import 'package:eshop/Helper/String.dart';
import 'package:eshop/Model/brandModel.dart';
import 'package:eshop/ui/widgets/ApiException.dart';

class BrandsRepository {
  Future<List<BrandData>> getAllBrands() async {
    try {
      final responseData = await ApiBaseHelper().postAPICall(getBrandsApi, {});
      return responseData['data']
          .map<BrandData>((e) => BrandData.fromJson(e))
          .toList();
    } on Exception catch (e, st) {
      print("This is GEt Brands:- $st");
      throw ApiException('$errorMesaage$e');
    }
  }
}
