import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:newsweb/view/layout/util.dart';
import 'package:newsweb/model/auth_service.dart';

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
  bool loggedIn = false;

  @override
  void initState() {
    super.initState();
    checkAccess();
  }

  Future<void> checkAccess() async {
    final result = await AuthService.sharedInstance.checkAccess();
    if (mounted) {
      setState(() {
        loggedIn = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        automaticallyImplyLeading: false,
        actions: 
          [
            ...widget.actions,
              if (loggedIn)
                Util.btn(
                  Icons.webhook,
                  'Admin',
                  () {
                    Navigator.of(context).pop();
                    context.go('/admin');
                  },
                )
              else
                Util.btn(
                    Icons.logout,
                    'Login',
                    () async {
                        await AuthService.sharedInstance.login();
                    },
                ),
          ],
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
    );
  }
}
