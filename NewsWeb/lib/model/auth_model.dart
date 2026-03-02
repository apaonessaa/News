import 'dart:typed_data';
import 'package:newsweb/model/entity/article.dart';
import 'package:newsweb/model/entity/paging.dart';
import 'package:newsweb/model/entity/category.dart';
import 'package:newsweb/model/entity/subcategory.dart';
import 'package:newsweb/model/service.dart';
import 'package:newsweb/model/endpoints.dart';

class User 
{
    String email;
    String username;

    User({
        required this.email,
        required this.username,
    });

    factory User.fromJson(Map<String, dynamic> json) 
    {
        return User(
            email: json['email'] ?? '',
            username: json['preferredUsername'] ?? ''
        );
    }

    Map<String, dynamic> toJson() => {
        'email': email,
        'preferredUsername': username
    };
}

class AuthModel 
{
    static AuthModel sharedInstance = AuthModel();

    Future<User> logged() async 
    {
        try {
            dynamic response = await Service.request(
                HttpMethod.GET,
                Endpoints.USER_INFO,
                '', 
            );
            if (response != null) {
                return User.fromJson(response);
            } else {
                return User(email:'',username:'');
            }
        } catch (error) {
            throw Exception('Errore nella richiesta di user info: $error');
        }
    }

    Future<void> login() async 
    {
        try {
            await Service.request(
                HttpMethod.GET,
                Endpoints.LOGIN,
                '',
            );
        } catch (error) {
            throw Exception('Errore con il login dell\'utente: $error');
        }
    }

    Future<void> logout() async 
    {
        try {
            await Service.request(
                HttpMethod.GET,
                Endpoints.LOGOUT,
                '',
            );
        } catch (error) {
            throw Exception('Errore con il logout dell\'utente: $error');
        }
    }
}