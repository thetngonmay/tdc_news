import 'package:news_app2/network/response/error_response.dart';
import 'package:news_app2/network/response/response_model.dart';
import 'package:news_app2/network/service/api.dart';
import 'package:news_app2/network/service/api_endpoint.dart';
import 'package:news_app2/network/service/api_response.dart';

class ArticleRepository {
  final Api api;

  ArticleRepository(this.api);

  Future<ApiResponse<ResponseModel, ErrorResponse>> fetchEverything({
    required String searchKey,
    int pageSize = 20,
    int page = 1,
  }) {
    final url = EndPoint.everything(searchKey);
    return api.get<ResponseModel>(
      url,
      fromJson: (map) => ResponseModel.fromMap(map),
      queryParams: {
        'pageSize': pageSize.toString(),
        'page': page.toString()
      }
    );
  }

  Future<ApiResponse<ResponseModel, ErrorResponse>> fetchTopHeadLine({
    required String country,
    int pageSize = 20,
    int page = 1,
  }) {
    final url = EndPoint.topHeadLine(country);
    return api.get<ResponseModel>(
      url,
      fromJson: (map) => ResponseModel.fromMap(map),
        queryParams: {
          'pageSize': pageSize.toString(),
          'page': page.toString()
        }
    );
  }
}
