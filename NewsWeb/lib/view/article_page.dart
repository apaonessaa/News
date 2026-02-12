import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:newsweb/model/retrive_data.dart';
import 'package:newsweb/model/entity/article.dart';
import 'package:newsweb/view/layout/custom_page.dart';
import 'package:newsweb/view/layout/cat_subcat_footer.dart';
import 'package:newsweb/view/layout/image_viewer.dart';
import 'package:newsweb/view/layout/util.dart';
import 'package:newsweb/view/layout/quill_text_display.dart';

class ArticlePage extends StatefulWidget 
{
    String title;
    ArticlePage({super.key, required this.title});
    @override
    _ArticlePage createState() => _ArticlePage();
}

class _ArticlePage extends State<ArticlePage> 
{
    Article? art;
    bool isLoading = true;
    bool hasError = false;

    @override
    void initState() {
        super.initState();
        getArticle();
    }

    void getArticle() 
    {
        RetriveData.sharedInstance
            .getArticle(widget.title)
                .then((result) {
                    setState(() {
                        art = result;
                        isLoading = false;
                    });
                })
                .catchError((error) {
                    setState(() {
                        art = null;
                        isLoading = false;
                        hasError = true;
                    });
                });
    }

    @override
    void dispose() {
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
                        [ Util.error("Errore nel caricamento dell'articolo.") ], 
                        maxWidth
                    ),
                    const SizedBox(height: 100),
                    const SizedBox.shrink(),
                    const CatAndSubcatFooter(),
                ]
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
                const CatAndSubcatFooter()
            ],
        );
    }
  
    List<Widget> _build(BuildContext context) {
        return [
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    const SizedBox(height: 10.0),

                    // Category
                    GestureDetector(
                        onTap: () => context.go('/category/${art!.category}'),
                        child: Text(
                            art!.category,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                            )
                        )
                    ),

                    const SizedBox(height: 30),
                    
                    // Article Image
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                        child: ImageViewer(title: art!.title)
                    ),

                    const SizedBox(height: 15),
                    Text(
                        art!.title,
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.start,
                    ),
                
                    const SizedBox(height: 10),

                    QuillTextDisplay(text: art!.summary),
                    //Text(
                    //    art!.summary,
                    //    style: Theme.of(context).textTheme.bodyLarge,
                    //    textAlign: TextAlign.start,
                    //),
                    const SizedBox(height: 10),
                    const Divider(),
                    const SizedBox(height: 10),

                    // Subcategory
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            ...art!.subcategory.map((subcat) {
                                return Padding(
                                    padding: const EdgeInsets.only(right: 4.0, bottom: 2.0),
                                    child: TextButton(
                                        style: TextButton.styleFrom(
                                            backgroundColor: Colors.red,
                                        ),
                                        onPressed: () => context.go('/category/${art!.category}/subcategory/${subcat}'),
                                        child: Text(
                                            subcat,
                                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 15,
                                                color: Colors.white,
                                            )                                    
                                        )
                                    )
                                );
                            })
                        ]
                    ),
                    const SizedBox(height: 20),
                    QuillTextDisplay(text: art!.content),
                    //Text(
                    //    art!.content,
                    //    style: Theme.of(context).textTheme.bodyMedium,
                    //    textAlign: TextAlign.start,
                    //),     
                ],
            ),
        ];
  }
}