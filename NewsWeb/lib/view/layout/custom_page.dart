import 'package:flutter/material.dart';
import 'package:newsweb/view/layout/util.dart';
import 'package:newsweb/view/theme/theme.dart';
import 'package:newsweb/view/layout/category_drawer.dart';

class CustomPage extends StatefulWidget {
  final List<Widget> actions;
  final List<Widget> content;
  const CustomPage({super.key, required this.actions, required this.content});
  
  @override
  State<CustomPage> createState() => _CustomPage();
}

class _CustomPage extends State<CustomPage> 
{
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        automaticallyImplyLeading: false,
        actions: widget.actions,
        //leading: IconButton(
        //  icon: Icon(Icons.menu),
        //  onPressed: () {
        //    NavigationService.scaffoldKey.currentState?.openDrawer();
        //  },
        ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(8.0),
            controller: scrollController,
            children: [
              ...widget.content,
            ],
          ),
        ],
      ),
      //drawer: _buildCustomDrawer(),
    );
  }

  Widget _buildCustomDrawer() {
    return Drawer(
      elevation: 16,
      child: Material(
        color: Colors.transparent,
        child: Container(
          color: Colors.white.withOpacity(0.9),
          child: CategoryDrawer(),
        ),
      ),
    );
  }
}
