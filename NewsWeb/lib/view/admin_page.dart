import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:newsweb/model/retrive_data.dart';
import 'package:newsweb/model/entity/article.dart';
import 'package:newsweb/view/layout/custom_page.dart';
import 'package:newsweb/view/layout/article_page/layer.dart';
import 'package:newsweb/view/layout/image_viewer.dart';
import 'package:newsweb/view/layout/util.dart';

class AdminPage extends StatefulWidget 
{ 
    const AdminPage({super.key}); 
    @override _AdminPage createState() => _AdminPage(); 
}

class _AdminPage extends State<AdminPage> 
{
    late List<Article> articles;
    bool isLoading = true;
    bool hasError = false;

    List<Article> page = [];
    int pageNumber = 0;
    int pageSize = 6;
    int maxPageNumber = 0;

    @override
    void initState() 
    {
        super.initState();
        articles = [];
        _loadArticles();
    }

    Future<void> _loadArticles() async 
    {
        try {
            final result = await RetriveData.sharedInstance.getMainArticles(pageNumber, pageSize);
            setState(() {
                if (result != null) {
                    articles = result.content;
                    page = List.from(articles);                     
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

    void _nextPage() 
    {
        if (pageNumber < maxPageNumber - 1) {
            setState(() {
                pageNumber++;
                isLoading = true;
            });
            _loadArticles();
        }
    }

    void _previousPage() 
    {
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
        return CustomPage(
            actions: [
                Util.btn(
                    Icons.webhook,
                    'Home',
                    () => context.go('/'),
                ),
            ],
            content: [
                const SizedBox(height: 40.0),
                UtilsLayout.layout(_build(context), maxWidth),
                const SizedBox(height: 100),
                const SizedBox.shrink(),
            ],
        );
    }

    List<Widget> _build(BuildContext context) 
    {
        if (isLoading) {
            return [ Util.isLoading() ];
        }

        if (hasError) {
            return [ Util.error("Errore nel caricamento dell'articolo.") ];
        }

        if (page.isEmpty) {
            return [const Text("Nessun articolo disponibile.")];
        }

        return [
            if (page.isNotEmpty)
                Layer(
                    widgets: [
                        ListOfArticlesToModify(
                            articles: Util.getAndRemove<Article>(page, 6),
                        ),
                    ]
                ),
            const SizedBox(height: 20.0),
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

class ListOfArticlesToModify extends StatelessWidget {
  final List<Article>? articles;
  final double? width;
  final double? height;

  const ListOfArticlesToModify({
    super.key,
    this.articles,
    this.width = double.maxFinite,
    this.height = 300,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Card(
        elevation: 0.0,
        margin: const EdgeInsets.all(5.0),
        color: Theme.of(context).colorScheme.secondary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        child: Column(
          children: [
            for (int index = 0; index < articles!.length; index++)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (index > 0) Divider(),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    onTap: () => context.go('/admin/article/${articles![index].title}/update'),
                    leading: ImageViewer(title: articles![index].title),
                    title: Text(
                        articles![index].title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                        ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}