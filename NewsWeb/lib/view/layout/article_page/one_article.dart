import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:newsweb/model/entity/article.dart';
import 'package:newsweb/view/layout/image_viewer.dart';

///  Display Article like this:
///  -----------------
///  |               |
///  |   image       |
///  |               |
///  ---------------- 
///  Title
///  ----------------
///  Summary
///  ----------------

class OneArticle extends StatelessWidget {
  final Article? article;
  final double width;
  final double height;
  final double imageCover; // double in (0.0 , 1.0)
  final bool withSummary;

  const OneArticle({
    this.article, 
    this.width = double.maxFinite, 
    this.height = 300, 
    this.imageCover = 0.60,
    this.withSummary = false, 
    super.key
  });

  @override
  Widget build(BuildContext context) {
    if (article == null) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      height: height,
      child: Card(
        elevation: 0.0,
        margin: const EdgeInsets.all(5.0),
        color: Theme.of(context).colorScheme.secondary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        child: ListTile(
          onTap: () => context.go('/article/${article!.title}'),
          title: Padding(
            padding: const EdgeInsets.only(
              left: 0.5, 
              right: 0.5, 
              top: 0.5, 
              bottom: 0.5
            ),
            child: ImageViewer(title: article!.title)
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                article!.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5.0),
              if (withSummary) ...[
                Text(
                  article!.summary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
