import 'dart:convert';

import 'package:fb_bili/http/core/hi_net_adapter.dart';
import 'package:fb_bili/http/request/base_request.dart';
import 'package:http/http.dart' as http;

import 'hi_error.dart';

///http适配器
class HttpAdapter extends HiNetAdapter {
  @override
  Future<HiNetResponse<T>> send<T>(BaseRequest request) async {
    var response;
    var error;
    var uri = Uri.parse(request.url());
    Map<String, String> header = request.header.cast<String, String>();
    try {
      if (request.httpMethod() == HttpMethod.GET) {
        response = await http.get(uri, headers: header);
      } else if (request.httpMethod() == HttpMethod.POST) {
        header["content-type"] = "application/json";
        response = await http.post(uri,
            body: jsonEncode(request.params), headers: header);
      } else if (request.httpMethod() == HttpMethod.DELETE) {
        header["content-type"] = "application/json";
        response = await http.delete(uri,
            body: jsonEncode(request.params), headers: header);
      }
    } on http.ClientException catch (e) {
      error = e.message;
    }

    ///抛出HiNetError
    if (error != null) {
      throw HiNetError(response?.statusCode ?? -1, error.toString(),
          data: buildRes(response, request));
    }
    return buildRes(response, request);
  }

  ///构建HiNetResponse
  Future<HiNetResponse<T>> buildRes<T>(
      http.Response? response, BaseRequest request) {
    return Future.value(HiNetResponse(
        data: response?.body as T,
        request: request,
        statusCode: response?.statusCode,
        statusMessage: response?.reasonPhrase,
        extra: response));
  }
}
