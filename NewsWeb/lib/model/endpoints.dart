class Endpoints 
{
    static const String REMOTE_API = "http://server:8081/api/";
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

    //static const String SUMMARIZER = "http://summarizer:8083/";
    static const String CLASSIFIER = "http://classifier:8082/";
    static const String CORRECTOR = "http://corrector:8083/";
}