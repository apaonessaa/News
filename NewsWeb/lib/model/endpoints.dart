class Endpoints 
{
    static const String SERVICE_DOMAIN = String.fromEnvironment('SERVICE_DOMAIN', defaultValue:'localhost:8080');

    static String LOGIN = "http://$SERVICE_DOMAIN/oauth2/sign_in";
    static String LOGOUT = "http://$SERVICE_DOMAIN/oauth2/sign_out";
    static String CHECK_ACCESS = "http://$SERVICE_DOMAIN/oauth2/auth";
    static String USER_INFO = "http://$SERVICE_DOMAIN/oauth2/userinfo";
    static String PUBLIC_API = "http://$SERVICE_DOMAIN/public/api/";
    static String PROTECTED_API = "http://$SERVICE_DOMAIN/api/";
    static String CLASSIFIER = "http://$SERVICE_DOMAIN/ai/classifier";
    static String CORRECTOR = "http://$SERVICE_DOMAIN/ai/corrector";

    static const String ARTICLE = "articles";

    static String article(String title) {
        return "${ARTICLE}/${title}";
    }

    static String image(String title) {
        return "${article(title)}/image";
    }

    static const String CATEGORY = "categories";

    static String category(String category) {
        return "${CATEGORY}/${category}";
    } 

    static String subcategory(String category, String subcategory) {
        return "${CATEGORY}/${category}/subcategories/${subcategory}";
    }   

    static String category_articles(String category) {
        return "${CATEGORY}/${category}/articles";
    }

    static String subcategory_articles(String category, String subcategory) {
        return "${CATEGORY}/${category}/subcategories/${subcategory}/articles";
    }
}