import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:newsweb/view/theme/theme.dart';
import 'package:newsweb/view/theme/text_theme.dart';
import 'package:newsweb/view/layout/util.dart';
import 'package:newsweb/view/main_page.dart';

void main() 
{
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
    // Imposta il tema della tua app
    TextTheme textTheme = createTextTheme(context, "Atkinson Hyperlegible", "Atkinson Hyperlegible");
    MaterialTheme theme = MaterialTheme(textTheme);

    /// La configurazione delle route
    final GoRouter router = GoRouter(
      navigatorKey: NavigationService.navigatorKey,
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return const MainPage();
          },
          routes: <RouteBase>[
            GoRoute(
              path: '/art/:title',
              builder: (BuildContext context, GoRouterState state) {
                final title = state.pathParameters['title']!; 
                //return ArticlePage(title: title);
                return MainPage();
              },
            ),
            GoRoute(
              path: '/cat/:name',
              builder: (BuildContext context, GoRouterState state) {
                final name = state.pathParameters['name']!; 
                //return CategoryPage(catname: catname ?? 'Unknown Category');
                return MainPage();
              },
            ),
            GoRoute(
              path: '/subcat/:name',
              builder: (BuildContext context, GoRouterState state) {
                final name = state.pathParameters['name']!; 
                //return SubcategoryPage(subcatname: subcatname ?? 'Unknown Subcategory');
                return MainPage();
              },
            ),
            GoRoute(
              path: '/admin',
              builder: (BuildContext context, GoRouterState state) {
                return MainPage();
              },
            ),
          ],
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: theme.lightMediumContrast(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.1)),
          child: child!,
        );
      },
    );
  }
}
