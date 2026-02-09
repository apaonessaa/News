import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:newsweb/model/entity/article.dart';
import 'package:newsweb/model/retrive_data.dart';
import 'package:newsweb/view/layout/custom_page.dart';
import 'package:newsweb/view/layout/image_viewer.dart';
import 'package:newsweb/view/layout/util.dart';

class ArticlePage extends StatefulWidget 
{
  final String title;

  const ArticlePage({super.key, required this.title});

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> 
{
  Article? art;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() 
  {
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
  Widget build(BuildContext context) 
  {
    return CustomPage(
      actions: [
        Util.btn(
          Icons.webhook,
          'Home',
          () => context.go('/'),
        ),
      ],
      content: getContent()
    );
  }

  List<Widget> getContent() 
  {
    if (isLoading) {
      return [ Util.isLoading() ];
    }

    if (hasError) {
      return [ Util.error("Errore nel caricamento dell'articolo.") ];
    }

    return [
      Text(
        art!.category,
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          height: 1.5,
        ),
        textAlign: TextAlign.start,
      ),
      const SizedBox(height: 10),
      Text(
        art!.title,
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          height: 1.5,
        ),
        textAlign: TextAlign.start,
      ),
      const SizedBox(height: 10),
      Wrap(
        spacing: 8.0,
        children: art!.subcategory
            .map((sub) => Chip(label: Text(sub)))
            .toList(),
      ),
      const SizedBox(height: 10),
      Text(
        art!.summary,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.normal,
          letterSpacing: 0.5,
          height: 1.5,
        ),
        textAlign: TextAlign.start,
      ),
      const SizedBox(height: 10),
      ImageViewer(title: art!.title),
      const SizedBox(height: 10),
      Text(
        art!.content,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          letterSpacing: 0.5,
          height: 1.5,
        ),
        textAlign: TextAlign.start,
      ),
    ];
  }
}

