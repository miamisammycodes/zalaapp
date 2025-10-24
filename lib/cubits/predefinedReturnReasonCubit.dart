import 'package:eshop/Model/predefiendReasonsModel.dart';
import 'package:eshop/repository/predefinedReturnRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class PredefinedReturnReasonListState {}

class PredefinedReturnReasonListInitial
    extends PredefinedReturnReasonListState {}

class PredefinedReturnReasonListInProgress
    extends PredefinedReturnReasonListState {}

class PredefinedReturnReasonListSuccess
    extends PredefinedReturnReasonListState {
  final List<PredefiendReasonsModel> predefined;
  PredefinedReturnReasonListSuccess({required this.predefined});
}

class PredefinedReturnReasonListFailure
    extends PredefinedReturnReasonListState {
  final String errorMessage;
  PredefinedReturnReasonListFailure(this.errorMessage);
}

class PredefinedReturnReasonListCubit
    extends Cubit<PredefinedReturnReasonListState> {
  final PredefinedReturnRepository predefinedreturnrepository;
  PredefinedReturnReasonListCubit({required this.predefinedreturnrepository})
      : super(PredefinedReturnReasonListInitial());
  Future<void> getpredefinedReturnReason({
    required String id,
    required String return_reason,
    required String message,
    required String image,
    int? limit,
    int offset = 0,
    String search = "",
  }) async {
    emit(PredefinedReturnReasonListInProgress());
    try {
      // ✅ Print parameters before making API call
      print("📤 Sending API Request with parameters:");
      final Map<String, dynamic> params = {
        "id": id,
        "return_reason": return_reason,
        "message": message,
        "image": image,
        "offset": offset.toString(),
        "search": search,
      };
      if (limit != null) {
        params["limit"] = limit.toString(); // Include only if needed
      }
      print(params);

      final response = await predefinedreturnrepository
          .getPredefinedReturnRepository(parameter: params);
          

      // ✅ Print API response
      print("✅ API Response Received:");
      print(response);

      emit(PredefinedReturnReasonListSuccess(predefined: response));
    } catch (e) {
      print("❌ API Request Failed: $e");
      emit(PredefinedReturnReasonListFailure(e.toString()));
    }
  }
}
