import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:slash_task/shared/assets_utils.dart';
import 'package:sprintf/sprintf.dart';

import '../base.dart';

/// represents a string API path in the backend server
/// takes only one parameter [_path] the path in the api
class ApiPath{
  final String _path;

  /// converts this object into its right [Uri], while encoding
  /// the link with the [params]
  Uri url({Map<String,dynamic>? params}) {
    return Uri.https(API_LINK , _path , params);
  }

  /// generates an [ApiPath] from a string
  static ApiPath fromString(String str){
    return ApiPath._(str);
  }

  /// formats a the [_path] using String formatting and returns
  /// an [ApiPath] with the new formatted string
  ApiPath format(List list){
    String str;
    str = sprintf(_path,list);
    return ApiPath._(str);
  }

  /// adds a directory to this [ApiPath]
  /// takes one input [directory] the directory to append
  ApiPath appendDirectory(String directory) => ApiPath._("$_path/$directory");

  const ApiPath._(String p) : _path = p;

  //TODO: add paths here
  static ApiPath fetchBestSelling       = const ApiPath._("/v3/b/6675d9dead19ca34f87ca35c");
  static ApiPath fetchNewArrivals       = const ApiPath._("/v3/b/6675d9e7e41b4d34e406e9d4");
  static ApiPath fetchOffers            = const ApiPath._("/v3/b/6675d9edacd3cb34a85b20b7");
  static ApiPath fetchRecommended       = const ApiPath._("/v3/b/6675d9f5acd3cb34a85b20bc");

}

class ApiResponse<T> {
  T? data;
  int code;
  String? responseBody;

  ApiResponse({
    this.data,
    required this.code,
    required this.responseBody,
  });

  void log(){
    print("ApiResponse{code: $code , data: $data , body: $responseBody}");
  }

  static const int CODE_SUCCESS = 200;
  static const int CODE_SUCCESS_CREATED = 201;
  static const int CODE_SUCCESS_NO_BODY = 204;
  static const int CODE_BAD_REQUEST = 400;
  static const int CODE_NOT_FOUND = 404;
  static const int CODE_TIMEOUT = 1000;
  static const int CODE_NO_INTERNET = 1001;
  static const int CODE_NOT_AUTHORIZED = 401;
  static const int CODE_UNKNOWN = -1;

}

class Api {

  Api._();

  /// inserts an authorization header using the [token] while also adding the JSON content header
  static Map<String,String> getTokenWithJsonHeader(String token){
    return getJsonHeader({
      "authorization" : token
    });
  }

  /// inserts an authorization header using the [token]
  static Map<String,String> getTokenHeader(String token){
    return {
      "authorization" : token
    };
  }

  /// adds the [JSON_TYPE_HEADER] to the headers
  static Map<String,String> getJsonHeader(Map<String,String> m){
    Map<String,String> map ={};
    map.addAll(m);
    map.addAll(JSON_TYPE_HEADER);
    return map;
  }

  /// a header that defines a JSON content type used in API communication
  static final Map<String,String> JSON_TYPE_HEADER = {"Content-Type": "application/json"};

  /// the actual implementation of the POST with no files functionality
  /// takes [url] the URL address of the end point
  /// [headers] the headers that will be used in the request
  /// [body] the body that will be used (normally a json string)
  /// [encoding] the content encoding (normally UTF8)
  static Future<ApiResponse<T>> _apiPostNoFilesImpl<T>(Uri url , Map<String,String>? headers , Object? body , Encoding encoding) async {
    try {
      var response = await http.post(
        url,
        headers: headers,
        body: body,
        encoding: encoding,
      ).timeout(API_TIMEOUT);
      return ApiResponse<T>(code: response.statusCode, responseBody: response.body);
    } on SocketException {
      return ApiResponse<T>(code: ApiResponse.CODE_NO_INTERNET, responseBody: null);
    } on TimeoutException {
      return ApiResponse<T>(code: ApiResponse.CODE_TIMEOUT, responseBody: null);
    } on Error catch (e) {
      print(e);
      return ApiResponse<T>(code: ApiResponse.CODE_UNKNOWN, responseBody: null);
    }
  }

  /// the actual implementation of the POST with file functionality
  /// takes [url] the URL address of the end point
  /// [headers] the headers that will be used in the request
  /// [body] the body that will be used (normally a json string)
  /// [files] the files to upload with the request
  /// [encoding] the content encoding (normally UTF8)
  static Future<ApiResponse<T>> _apiPostFilesImpl<T>(Uri url , Map<String,String>? headers , Object? body , List<http.MultipartFile> files , Encoding encoding) async {
    try {
      var request = http.MultipartRequest("POST" , url);
      request.headers.addAll(headers ?? {});
      if (body != null) {
        if (body is Map<String , String>){
          request.fields.addAll(body);
        }else{
          print("_apiPostFilesImpl: tried to add a body that is not a map");
        }
      }
      request.files.addAll(files);

      var response = await request.send();
      var response2 = await http.Response.fromStream(response);
      return ApiResponse<T>(code: response.statusCode, responseBody: String.fromCharCodes(response2.bodyBytes));
    } on SocketException {
      return ApiResponse<T>(code: ApiResponse.CODE_NO_INTERNET, responseBody: null);
    } on TimeoutException{
      return ApiResponse<T>(code: ApiResponse.CODE_TIMEOUT, responseBody: null);
    } on Error catch (e) {
      print(e);
      return ApiResponse<T>(code: ApiResponse.CODE_UNKNOWN, responseBody: null);
    }
  }

  /// the API POST function interface
  /// takes :
  /// [path] an API path for the end point
  /// [params] link params used in the request
  /// [headers] headers used in the request
  /// [body] the request body
  /// [files] the files to upload
  /// [encoding] the content encoding of the body
  static Future<ApiResponse<T>> apiPost<T>(
      ApiPath path ,
      {
        Map<String,dynamic>? params ,
        Map<String,String>? headers ,
        Object? body ,
        List<http.MultipartFile>? files ,
        Encoding? encoding ,
      }
      ) async {

    encoding ??= Encoding.getByName("utf-8");
    if (files == null){ //not an upload request
      return _apiPostNoFilesImpl<T>(path.url(params: params) , headers , body , encoding!);
    }
    return _apiPostFilesImpl<T>(path.url(params: params) , headers , body , files , encoding!);
  }


  /// the actual implementation of the GET with no files functionality
  /// takes [url] the URL address of the end point
  /// [headers] the headers that will be used in the request
  /// [body] the body that will be used (normally a json string)
  /// [encoding] the content encoding (normally UTF8)
  static Future<ApiResponse<T>> _apiGetNoFilesImpl<T>(Uri url , Map<String,String>? headers) async {
    try{
      var response = await http.get(
        url,
        headers: headers,
      ).timeout(API_TIMEOUT);
      //dynamic responsePayload = json.decode(response.body);
      return ApiResponse<T>(code: response.statusCode, responseBody: response.body);
    } on SocketException {
      return ApiResponse<T>(code: ApiResponse.CODE_NO_INTERNET, responseBody: null);
    } on TimeoutException {
      return ApiResponse<T>(code: ApiResponse.CODE_TIMEOUT, responseBody: null);
    } on Error catch (e) {
      print(e);
      return ApiResponse<T>(code: ApiResponse.CODE_UNKNOWN, responseBody: null);
    }
  }

  /// the API GET function interface
  /// takes :
  /// [path] an API path for the end point
  /// [params] link params used in the request
  /// [headers] headers used in the request
  static Future<ApiResponse<T>> apiGet<T>(
      ApiPath path ,
      {
        Map<String,dynamic>? params ,
        Map<String,String>? headers ,
      }
      ) async {

    if (!mockAPI){
      headers ??= JSON_TYPE_HEADER;
      return _apiGetNoFilesImpl<T>(path.url(params: params) , headers );
    }

    /// load form assets for testing ..
    await Future.delayed(const Duration(milliseconds: 2000));
    String item = "offers.json";

    if (path._path == ApiPath.fetchBestSelling._path) {
      item = "best_selling.json";
    } else if (path._path == ApiPath.fetchNewArrivals._path) {
      item = "new_arrivals.json";
    } else if (path._path == ApiPath.fetchRecommended._path) {
      item = "recommended.json";
    }

    return ApiResponse(code: 0, responseBody: await loadAsset("assets/data/$item"));
  }

  /// the actual implementation of the PATCH with no files functionality
  /// takes [url] the URL address of the end point
  /// [headers] the headers that will be used in the request
  /// [body] the body that will be used (normally a json string)
  /// [encoding] the content encoding (normally UTF8)
  static Future<ApiResponse<T>> _apiPatchNoFilesImpl<T>(Uri url , Map<String,String>? headers , Object? body , Encoding encoding) async {
    try {
      var response = await http.patch(
        url,
        headers: headers,
        body: body,
        encoding: encoding,
      ).timeout(API_TIMEOUT);
      return ApiResponse<T>(code: response.statusCode, responseBody: response.body);
    } on SocketException {
      return ApiResponse<T>(code: ApiResponse.CODE_NO_INTERNET, responseBody: null);
    } on TimeoutException {
      return ApiResponse<T>(code: ApiResponse.CODE_TIMEOUT, responseBody: null);
    } on Error catch (e) {
      print(e);
      return ApiResponse<T>(code: ApiResponse.CODE_UNKNOWN, responseBody: null);
    }
  }

  /// the actual implementation of the PATCH with file functionality
  /// takes [url] the URL address of the end point
  /// [headers] the headers that will be used in the request
  /// [body] the body that will be used (normally a json string)
  /// [files] the files to upload with the request
  /// [encoding] the content encoding (normally UTF8)
  static Future<ApiResponse<T>> _apiPatchFilesImpl<T>(Uri url , Map<String,String>? headers , Object? body , List<http.MultipartFile> files , Encoding encoding) async {
    try {
      var request = http.MultipartRequest("PATCH" , url);
      request.headers.addAll(headers ?? {});
      if (body != null) {
        if (body is Map<String , String>){
          request.fields.addAll(body);
        }else{
          print("_apiPostFilesImpl: tried to add a body that is not a map");
        }
      }
      request.files.addAll(files);

      var response = await request.send();
      var response2 = await http.Response.fromStream(response);
      return ApiResponse<T>(code: response.statusCode, responseBody: String.fromCharCodes(response2.bodyBytes));
    } on SocketException {
      return ApiResponse<T>(code: ApiResponse.CODE_NO_INTERNET, responseBody: null);
    } on TimeoutException{
      return ApiResponse<T>(code: ApiResponse.CODE_TIMEOUT, responseBody: null);
    } on Error catch (e) {
      print(e);
      return ApiResponse<T>(code: ApiResponse.CODE_UNKNOWN, responseBody: null);
    }
  }

  /// the API PATCH function interface
  /// takes :
  /// [path] an API path for the end point
  /// [params] link params used in the request
  /// [headers] headers used in the request
  /// [body] the request body
  /// [files] the files to upload
  /// [encoding] the content encoding of the body
  static Future<ApiResponse<T>> apiPatch<T>(
      ApiPath path ,
      {
        Map<String,dynamic>? params ,
        Map<String,String>? headers ,
        Object? body ,
        List<http.MultipartFile>? files ,
        Encoding? encoding ,
      }
      ){
    encoding ??= Encoding.getByName("utf-8");
    if (files == null){ //not an upload request
      return _apiPatchNoFilesImpl<T>(path.url(params: params) , headers , body , encoding!);
    }
    return _apiPatchFilesImpl<T>(path.url(params: params) , headers , body , files , encoding!);
  }

  /// the actual implementation of the DELETE with no files functionality
  /// takes [url] the URL address of the end point
  /// [headers] the headers that will be used in the request
  /// [encoding] the content encoding (normally UTF8)
  static Future<ApiResponse<T>> _apiDeleteNoFilesImpl<T>(Uri url , Map<String,String>? headers , Encoding encoding) async {
    try {
      var response = await http.delete(
        url,
        headers: headers,
        encoding: encoding,
      ).timeout(API_TIMEOUT);
      return ApiResponse<T>(code: response.statusCode, responseBody: response.body);
    } on SocketException {
      return ApiResponse<T>(code: ApiResponse.CODE_NO_INTERNET, responseBody: null);
    } on TimeoutException {
      return ApiResponse<T>(code: ApiResponse.CODE_TIMEOUT, responseBody: null);
    } on Error catch (e) {
      print(e);
      return ApiResponse<T>(code: ApiResponse.CODE_UNKNOWN, responseBody: null);
    }
  }

  /// the API DELETE function interface
  /// takes :
  /// [path] an API path for the end point
  /// [params] link params used in the request
  /// [headers] headers used in the request
  /// [encoding] the content encoding of the body
  static Future<ApiResponse<T>> apiDelete<T>(
      ApiPath path ,
      {
        Map<String,dynamic>? params ,
        Map<String,String>? headers ,
        Encoding? encoding ,
      }
      ){
    encoding ??= Encoding.getByName("utf-8");

    return _apiDeleteNoFilesImpl<T>(path.url(params: params) , headers , encoding!);
  }
}