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
}