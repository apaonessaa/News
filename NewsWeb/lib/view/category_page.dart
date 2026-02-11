import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:newsweb/model/retrive_data.dart';
import 'package:newsweb/model/entity/article.dart';
import 'package:newsweb/view/layout/custom_page.dart';
import 'package:newsweb/view/layout/article_page/layer.dart';
import 'package:newsweb/view/layout/article_page/list_article.dart';
import 'package:newsweb/view/layout/article_page/one_article.dart';
import 'package:newsweb/view/layout/article_page/stack_article.dart';
import 'package:newsweb/view/layout/cat_subcat_footer.dart';
import 'package:newsweb/view/layout/util.dart';

class CategoryPage extends StatefulWidget {
  final String categoryName;

  const CategoryPage({super.key, required this.categoryName});

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late List<Article> articles;
  bool isLoading = true;
  bool hasError = false;

  List<Article> page = [];
  int pageNumber = 0;
  int pageSize = 17;
  int maxPageNumber = 0;

  @override
  void initState() {
    super.initState();
    articles = [];
    _loadArticles();
  }

  Future<void> _loadArticles() async {
    try {
      final result = await RetriveData.sharedInstance.getArticleByCategory(
          widget.categoryName, pageNumber, pageSize);
      setState(() {
        if (result != null) {
          articles = result.content;
          page = List.from(articles);
          maxPageNumber = result.totalPages;
        }
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  void _nextPage() {
    if (pageNumber < maxPageNumber - 1) {
      setState(() {
        pageNumber++;
        isLoading = true;
      });
      _loadArticles();
    }
  }

  void _previousPage() {
    if (pageNumber > 0) {
      setState(() {
        pageNumber--;
        isLoading = true;
      });
      _loadArticles();
    }
  }

  @override
  void dispose() {
    articles.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = UtilsLayout.setWidth(context);
    if (isLoading) {
      return CustomPage(
        actions: [
          Util.btn(
            Icons.webhook,
            'Home',
            () => context.go('/'),
          ),
        ],
        content: [Util.isLoading()],
      );
    }

    if (hasError) {
      return CustomPage(
        actions: [
          Util.btn(
            Icons.webhook,
            'Home',
            () => context.go('/'),
          ),
        ],
        content: [
          UtilsLayout.layout(
            [Util.error("Errore nel caricamento dell'articolo.")],
            maxWidth,
          ),
          const SizedBox(height: 100),
          const SizedBox.shrink(),
          const CatAndSubcatFooter(),
        ],
      );
    }

    return CustomPage(
      actions: [
        Util.btn(
          Icons.webhook,
          'Home',
          () => context.go('/'),
        ),
      ],
      content: [
        UtilsLayout.layout(_build(context), maxWidth),
        const SizedBox(height: 100),
        const SizedBox.shrink(),
        const CatAndSubcatFooter(),
      ],
    );
  }

  List<Widget> _build(BuildContext context) {
    if (page.isEmpty) {
      return [const Text("Nessun articolo disponibile.")];
    }

    return [
        const SizedBox(height: 40.0),

        Text(
            widget.categoryName,
            style: Theme.of(context).textTheme.displayMedium,
            textAlign: TextAlign.start,
        ),

        const SizedBox(height: 40.0),

      // LAYER #1: Primo articolo in cima
      if (page.isNotEmpty)
        Layer(
          widgets: [
            OneArticle(
              article: page.removeAt(0),
              imageCover: 0.65,
              height: 502,
              withSummary: true,
            ),
            if (page.isNotEmpty)
              StackOfArticles(
                articles: Util.getAndRemove<Article>(page, 3),
                withImage: true,
                imageCover: 0.50,
                height: 502,
              ),
          ],
        ),

      // LAYER #2: Altri articoli con layout alternato
      if (page.isNotEmpty) ...[
        const SizedBox(height: 50.0),
        Layer(widgets: [
          StackOfArticles(
            articles: Util.getAndRemove<Article>(page, 3),
            withImage: false,
            height: 502,
            imageCover: 0.5,
          ),
          if (page.isNotEmpty)
            Column(
              children: [
                if (page.isNotEmpty)
                  OneArticle(
                    article: page.removeAt(0),
                    height: 250,
                    imageCover: 0.65,
                  ),
                if (page.isNotEmpty)
                  OneArticle(
                    article: page.removeAt(0),
                    height: 250,
                    imageCover: 0.65,
                  ),
              ],
            ),
        ])
      ],

      // LAYER #3: Altri articoli nella parte inferiore
      if (page.isNotEmpty) ...[
        const SizedBox(height: 50.0),
        Layer(
          widgets: [
            Column(
              children: [
                if (page.length > 1)
                  OneArticle(
                    article: page.removeAt(0),
                    height: 251,
                    imageCover: 0.65,
                  ),
                if (page.length > 1)
                  OneArticle(
                    article: page.removeAt(0),
                    height: 251,
                    imageCover: 0.65,
                  ),
              ],
            ),
            if (page.isNotEmpty)
              ListOfArticles(
                articles: Util.getAndRemove<Article>(page, 6),
                withImage: true,
                height: 502,
              ),
          ],
        ),
      ],
        
        // Paginazione
        // Paginazione con pulsanti e testo all'estremo destro
        const Spacer(flex: 1),
        Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
                IconButton(
                    icon: const Icon(Icons.arrow_circle_left, color: Colors.red),
                    onPressed: () {
                        // update page number and full state
                        if(pageNumber>0) {
                            pageNumber-=1;
                            _previousPage();
                        }
                    },
                ),
                IconButton(
                    icon: const Icon(Icons.arrow_circle_right, color: Colors.red),
                    onPressed: () {
                        // update page number and full state
                        if (pageNumber+1<maxPageNumber) {
                            pageNumber+=1;
                            _nextPage();
                        }
                    },
                ),
            ],
        ),

        Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
                Text(
                    '${maxPageNumber!=0 ? pageNumber+1 : pageNumber}/$maxPageNumber', 
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary, 
                        fontSize: 12.0, 
                        fontWeight: FontWeight.normal),
                ),
            ],
        ),
    ];
  }
}
