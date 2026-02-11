class Endpoints 
{
    static const String REMOTE_API = "http://localhost:8081/api/";
    static const String ARTICLE = "articles";

    static String article(String title) {
        return "${ARTICLE}/${title}";
    }

    static String image(String title) {
        return "${article(title)}/image";
    }

    static const String CATEGORY = "categories";

    static String subcategory(String category) {
        return "${CATEGORY}/${category}/subcategories";
    }   

    static String category_articles(String category) {
        return "${CATEGORY}/${category}/articles";
    }
}