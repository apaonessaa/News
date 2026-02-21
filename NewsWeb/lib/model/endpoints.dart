class Endpoints 
{
    static const String REMOTE_API = "http://localhost:8080/api/";
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
    static const String CLASSIFIER = "http://localhost:8080/ai/classifier/";
    static const String CORRECTOR = "http://localhost:8080/ai/corrector/";
}