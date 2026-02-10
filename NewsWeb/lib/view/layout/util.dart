import 'package:flutter/material.dart';

class NavigationService 
{ 
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
}

class Util
{
    static Widget btn(IconData icon, String label, Function() goTo) 
    {
        return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
            icon: Icon(icon, size: 24),
            label: Text(label),
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                ),
            ),
            onPressed: () => goTo()
            )
        );
    }

    static Widget isLoading() {
        return const Center(
          child: CircularProgressIndicator(),
        );
    }

    static Widget error(String text) 
    {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 40,
              ),
              SizedBox(height: 10),
              Text(
                text,
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            ],
          ),
        );
    }

    static List<T> getAndRemove<T>(List<T> list, int count) {
      final int end = list.length < count ? list.length : count;
      final List<T> sublist = list.sublist(0, end);
      list.removeRange(0, end);
      return sublist;
    }
  
    static List<T> pagedList<T>(List<T> list, int pageNumber, int pageSize) {
      if(list.isEmpty) {
        return [];
      }

      int start = pageNumber*pageSize;
      int end = start + pageSize;

      if(list.length<start) {
        start = list.length;
      }

      if(list.length<end) {
        end = list.length;
      }
      return list.sublist(start,end);
    }
}

///////////////////////// LAYOUT /////////////////////////////////
final class UtilsLayout {
  // Boxed Content
  static Widget layout(List<Widget> content, double maxWidth) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          const Expanded(child: SizedBox()), // Left spacer
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Column(
              children: content,
            ),
          ),
          const Expanded(child: SizedBox()), // Right spacer
        ],
      ),
    );
  }
}
