import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

enum HttpMethod { POST, GET, PUT, DELETE }
enum TypeHeader { JSON, URL_ENCODED, IMAGE }

class Service {
  static Future<dynamic> request(
      HttpMethod method,
      String serverAddress,
      String servicePath, {
        TypeHeader? type,
        Map<String, String>? params,
        dynamic body,
      }) async {
    Uri uri = Uri.parse(serverAddress).resolve(servicePath).replace(queryParameters: params);

    Map<String, String> headers = {};
    dynamic requestBody;

    // Gestione della richiesta per diversi tipi di contenuto
    if (type == null || type == TypeHeader.JSON) {
      headers[HttpHeaders.contentTypeHeader] = 'application/json;charset=utf-8';
      requestBody = json.encode(body);
    } else if (type == TypeHeader.URL_ENCODED) {
      headers[HttpHeaders.contentTypeHeader] = 'application/x-www-form-urlencoded';
      requestBody = body?.keys.map((key) => "$key=${Uri.encodeComponent(body[key])}").join("&");
    } else if (type == TypeHeader.IMAGE) {
      headers[HttpHeaders.acceptHeader] = 'image/*';  // Supporta qualsiasi tipo di immagine
    }

    http.Response response;

    try {
      switch (method) {
        case HttpMethod.POST:
          response = await http.post(uri, headers: headers, body: requestBody);
          break;
        case HttpMethod.PUT:
          response = await http.put(uri, headers: headers, body: requestBody);
          break;
        case HttpMethod.GET:
          response = await http.get(uri, headers: headers);
          break;
        case HttpMethod.DELETE:
          response = await http.delete(uri, headers: headers);
          break;
        default:
          throw Exception('Unsupported HTTP method $method');
      }

      if (response.statusCode == HttpStatus.ok || 
          response.statusCode == HttpStatus.found ||
          response.statusCode == HttpStatus.noContent) {

        if (type == TypeHeader.IMAGE) {
          return response.bodyBytes;
        }

        return response.body.isEmpty ? null : jsonDecode(response.body);
      } else {
        throw Exception('Failed request with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('HTTP request error: $e');
    }
  }
}
