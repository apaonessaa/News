import 'dart:typed_data';
import 'package:mime/mime.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:newsweb/model/service.dart';
import 'package:newsweb/model/entity/article.dart';
import 'package:newsweb/model/service.dart';
import 'package:newsweb/model/endpoints.dart';

class SendData 
{
    static SendData sharedInstance = SendData();

    Future<void> save(
        Article art, 
        Uint8List imageBytes, 
        String imageFilename) async 
    {
        final mimeType = lookupMimeType(imageFilename);
        String subType = mimeType?.split('/').last ?? 'unknown';

        var articleJson = art.toJson();

        var request = http.MultipartRequest(
            'POST',
            Uri.parse('${Endpoints.REMOTE_API}${Endpoints.ARTICLE}')
            )
            ..files.add(
                http.MultipartFile.fromBytes(
                'article',
                utf8.encode(jsonEncode(articleJson)),
                filename: 'article.json', 
                contentType: MediaType('application', 'json'),
                ),
            )
            ..files.add(
                http.MultipartFile.fromBytes(
                'image',
                imageBytes,
                filename: imageFilename,
                contentType: MediaType('image', subType),
                ),
        );

        print(request.headers);
        
        try {
            var response = await request.send();
            if (response.statusCode == 201) {
                print("Articolo è stato salvato con successo!");
            } else {
                print("Errore nel salvataggio dell'articolo: ${response.statusCode}");
                var responseBody = await response.stream.bytesToString();
                print("Risposta dell'errore: $responseBody");
            }
        } catch (e) {
            print("Errore durante la richiesta HTTP: $e");
        }
    }

    Future<void> delete(String title) async 
    {
        try {
            dynamic response = await Service.request(
                HttpMethod.DELETE,
                Endpoints.REMOTE_API,
                Endpoints.article(title)
            );
            print("Articolo eliminato.");
        } catch (error) {
            print("Errore con l'eliminazione dell'articolo ${title}");
            throw Exception(error);
        }
    }
}