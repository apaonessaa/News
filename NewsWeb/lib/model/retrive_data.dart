import 'dart:typed_data';
import 'package:newsweb/model/entity/article.dart';
import 'package:newsweb/model/service.dart';
import 'package:newsweb/model/endpoints.dart';

class RetriveData {
    static RetriveData sharedInstance = RetriveData();

    Future<Article> getArticle(String title) async 
    {
        try {
            dynamic response = await Service.request(
                HttpMethod.GET,
                Endpoints.REMOTE_API,
                Endpoints.article(title)
            );
            return Article.fromJson(response);
        } catch (error) {
            throw Exception();
        }
    }

    Future<Uint8List> getImage(String title) async 
    {
        try {
            dynamic response = await Service.request(
                HttpMethod.GET,
                Endpoints.REMOTE_API,
                type: TypeHeader.IMAGE,
                Endpoints.image(title)
            );
            return response;
        } catch (error) {
            throw Exception();
        }
    }
}