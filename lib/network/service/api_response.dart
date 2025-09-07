import '../response/error_response.dart';

sealed class ApiResponse <S,E extends ErrorResponse>{
  const ApiResponse();
}
final class Success<S,E extends ErrorResponse> extends ApiResponse<S,E>{
  final S data;
  Success(this.data);
}
final class Fail<S,E extends ErrorResponse>extends ApiResponse<S,E>{
  final E error;
  Fail(this.error);

}