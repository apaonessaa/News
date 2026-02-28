class Endpoints 
{
    static const String SERVICE_DOMAIN = String.fromEnvironment('SERVICE_DOMAIN', defaultValue:'localhost:8080');

    static String SERVER = "http://$SERVICE_DOMAIN/api/";
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