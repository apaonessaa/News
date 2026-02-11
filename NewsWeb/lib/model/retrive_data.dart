import 'dart:typed_data';
import 'package:newsweb/model/entity/article.dart';
import 'package:newsweb/model/entity/paging.dart';
import 'package:newsweb/model/entity/category.dart';
import 'package:newsweb/model/service.dart';
import 'package:newsweb/model/endpoints.dart';

class RetriveData 
{
    static RetriveData sharedInstance = RetriveData();

    Future<PaginatedArticles?> getArticleByCategory(String cat, int pageNumber, int pageSize) async 
    {
        try {
            dynamic response = await Service.request(
            HttpMethod.GET,
            Endpoints.REMOTE_API,
            Endpoints.category_articles(cat),
            params: {
                'pageNumber': '$pageNumber',
                'pageSize': '$pageSize',
            },
            );

            if (response != null && response is Map<String, dynamic>) {
            print("API response: $response"); 
            return PaginatedArticles.fromJson(response);
            }
            return null;
        } catch (error) {
            print("Error fetching articles: $error");
            throw Exception('Error fetching articles');
        }
    }

    Future<PaginatedArticles?> getMainArticles(int pageNumber, int pageSize) async 
    {
        try {
            dynamic response = await Service.request(
            HttpMethod.GET,
            Endpoints.REMOTE_API,
            Endpoints.ARTICLE,
            params: {
                'pageNumber': '$pageNumber',
                'pageSize': '$pageSize',
            },
            );

            if (response != null && response is Map<String, dynamic>) {
            print("API response: $response"); 
            return PaginatedArticles.fromJson(response);
            }
            return null;
        } catch (error) {
            print("Error fetching articles: $error");
            throw Exception('Error fetching articles');
        }
    }

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

    Future<List<Category>> getCategories() async 
    {
        try {
            dynamic response = await Service.request(
                HttpMethod.GET,
                Endpoints.REMOTE_API,
                Endpoints.CATEGORY
            );
            if (response == null) {
                return [];
            }

            List<Category> categories = [];
            for (var categoryJson in response) {
                categories.add(Category.fromJson(categoryJson));
            }
            return categories;
        } catch (error) {
            throw Exception();
        }
    }
}