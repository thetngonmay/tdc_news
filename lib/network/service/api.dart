import 'dart:convert';

import 'package:http/http.dart';
import 'package:news_app2/network/response/error_response.dart';
import 'package:news_app2/network/service/api_response.dart';

typedef FromJson<T> = T Function(Map<String,dynamic> json);

class Api{
  Client client = Client();
  static String ApiKey='32461b66c2494cf2870fb004b50d6e20';
  
  Future<ApiResponse<T, ErrorResponse>> get<T>(
      String url,{
        required FromJson<T> fromJson,
        Map<String,String>? headers,
        Map<String,String>? queryParams,
  }) async{
    try{
      final uri = Uri.parse(_appendApiKey(url, queryParams));
      final response = await client.get(uri,headers: _mergeHeaders(headers));
      return _handleResponse(response,fromJson);
    }
    catch (e){
      return Fail(ErrorResponse("error","clientError",e.toString()));
    }
  }
  Future<ApiResponse<T,ErrorResponse>>post<T>(
      String url,{
        required FromJson<T>fromJson,
        Map<String,String>? headers,
        Map<String,String>? queryParms,
  } )async{
    try{
      final uri=Uri.parse(_appendApiKey(url));
      final response= await client.post(uri,headers: _mergeHeaders(headers),);
      return _handleResponse(response, fromJson);
    }catch (e){
      return Fail(ErrorResponse('error','client_error',e.toString()));

    }
  }
  Future<ApiResponse<T,ErrorResponse>>put<T>(
      String url,{
        required FromJson<T>fromJson,
        Map<String,String>? headers,
        Map<String,String>?queryParms
      })async{
    try{
      final uri=Uri.parse(_appendApiKey(url));
      final response=await client.delete(uri,headers: _mergeHeaders(headers));
      return _handleResponse(response, fromJson);
    }catch(e){
      return Fail(ErrorResponse('error','client_error',e.toString()));
    }
  }


 Future<ApiResponse<T,ErrorResponse>>delete<T>(
     String url,{
       required FromJson<T>fromJson,
       Map<String,String>? headers,
       Map<String,String>? queryParms
  } )async{
    try{
      final uri=Uri.parse(_appendApiKey(url));
      final response=await client.delete(uri,headers: _mergeHeaders(headers));
      return _handleResponse(response, fromJson);
    }catch(e){
      return Fail(ErrorResponse('error','client_error',e.toString()));
    }
 }



  String _appendApiKey(String url, [Map<String, String>? queryParams]) {
    final uri=Uri.parse(url);

    final updatedQuery={
      ...uri.queryParameters,
      'apiKey':ApiKey,
      ...?queryParams
    };

    final newUri=uri.replace(queryParameters: updatedQuery);

    return newUri.toString();

  }

  Map<String, String>? _mergeHeaders(Map<String, String>? headers) {
    return {
      'Content-Type' : 'application/json',
      ...?headers
    };
  }

  ApiResponse<T, ErrorResponse> _handleResponse<T>(Response response, FromJson<T> fromJson) {
    final data= jsonDecode(response.body);

    if(response.statusCode >=200 && response.statusCode < 300){
      return Success((fromJson(data)));
    }else {
      return Fail(ErrorResponse.fromMap(data));
    }

  }


}