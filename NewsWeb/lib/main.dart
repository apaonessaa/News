import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:newsweb/view/theme/theme.dart';
import 'package:newsweb/view/theme/text_theme.dart';
import 'package:newsweb/view/layout/util.dart';
import 'package:newsweb/view/article_page.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  const App({super.key});
  @override
  State<App> createState() => _App();
}

class _App extends State<App> {
  @override
  Widget build(BuildContext context) {
    // Theme
    TextTheme textTheme = createTextTheme(context, "Atkinson Hyperlegible", "Atkinson Hyperlegible");
    MaterialTheme theme = MaterialTheme(textTheme);

    /// The route configuration
    final GoRouter router = GoRouter(
      navigatorKey: NavigationService.navigatorKey,
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return const ArticlePage(title: 'Some Article Title');
          },
          routes: <RouteBase>[
            GoRoute(
              path: '/art',
              builder: (BuildContext context, GoRouterState state) {
                return const ArticlePage(title: 'Some Article Title');
              },
            ),
            // ...
          ],
        ),
      ],
    );

    return  MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: theme.lightMediumContrast(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.1)),
          child: child!,
        );
      }
    );
  }
}