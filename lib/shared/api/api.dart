import 'dart:convert';

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
  static ApiPath fetchBestSelling       = const ApiPath._("api/bestSelling");
  static ApiPath fetchNewArrivals       = const ApiPath._("api/arrivals");
  static ApiPath fetchOffers            = const ApiPath._("api/offers");
  static ApiPath fetchRecommended       = const ApiPath._("api/recommended");

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

  static const CODE_SUCCESS = 0;
  static const CODE_FAILED  = 1;

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
    // try {
    //   var response = await http.post(
    //     url,
    //     headers: headers,
    //     body: body,
    //     encoding: encoding,
    //   ).timeout(API_TIMEOUT);
    //   return ApiResponse<T>(code: response.statusCode, responseBody: response.body);
    // } on SocketException {
    //   return ApiResponse<T>(code: ApiResponse.CODE_NO_INTERNET, responseBody: null);
    // } on TimeoutException {
    //   return ApiResponse<T>(code: ApiResponse.CODE_TIMEOUT, responseBody: null);
    // } on Error catch (e) {
    //   print(e);
    //   return ApiResponse<T>(code: ApiResponse.CODE_UNKNOWN, responseBody: null);
    // }

    throw UnimplementedError();
  }

  /// the actual implementation of the POST with file functionality
  /// takes [url] the URL address of the end point
  /// [headers] the headers that will be used in the request
  /// [body] the body that will be used (normally a json string)
  /// [files] the files to upload with the request
  /// [encoding] the content encoding (normally UTF8)
  static Future<ApiResponse<T>> _apiPostFilesImpl<T>(Uri url , Map<String,String>? headers , Object? body , List<http.MultipartFile> files , Encoding encoding) async {
    // try {
    //   var request = http.MultipartRequest("POST" , url);
    //   request.headers.addAll(headers ?? {});
    //   if (body != null) {
    //     if (body is Map<String , String>){
    //       request.fields.addAll(body);
    //     }else{
    //       print("_apiPostFilesImpl: tried to add a body that is not a map");
    //     }
    //   }
    //   request.files.addAll(files);
    //
    //   var response = await request.send();
    //   var response2 = await http.Response.fromStream(response);
    //   return ApiResponse<T>(code: response.statusCode, responseBody: String.fromCharCodes(response2.bodyBytes));
    // } on SocketException {
    //   return ApiResponse<T>(code: ApiResponse.CODE_NO_INTERNET, responseBody: null);
    // } on TimeoutException{
    //   return ApiResponse<T>(code: ApiResponse.CODE_TIMEOUT, responseBody: null);
    // } on Error catch (e) {
    //   print(e);
    //   return ApiResponse<T>(code: ApiResponse.CODE_UNKNOWN, responseBody: null);
    // }

    throw UnimplementedError();
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

    // encoding ??= Encoding.getByName("utf-8");
    // if (files == null){ //not an upload request
    //   return _apiPostNoFilesImpl<T>(path.url(params: params) , headers , body , encoding!);
    // }
    // return _apiPostFilesImpl<T>(path.url(params: params) , headers , body , files , encoding!);

    /// for now, we simulate an API request by just doing a delay and then returning the dummy file from assets
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
}