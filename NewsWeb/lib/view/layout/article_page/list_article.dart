import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:newsweb/model/entity/article.dart';
import 'package:newsweb/view/layout/image_viewer.dart';

/// Display Articles like this (withImage):
/// ---------------- 
/// image1 title1
/// ---------------- 
/// image2 title2
/// ---------------- 
/// image3 title3
/// ----------------
/// ...
/// 
/// else:
/// ---------------- 
/// title1
/// ---------------- 
/// title2
/// ---------------- 
/// title3
/// ----------------

class ListOfArticles extends StatelessWidget {
  final List<Article>? articles;
  final bool withImage;
  final double? width;
  final double? height;

  const ListOfArticles({
    super.key,
    this.articles,
    this.width = double.maxFinite,
    this.height = 300,
    this.withImage = false,
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
                    onTap: () => context.go('/art/${articles![index].title}'),
                    leading: withImage
                        ? ImageViewer(title: articles![index].title)
                        : null,
                    title: Text(
                      articles![index].title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontWeight: FontWeight.w100
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