import 'package:flutter/material.dart';
import 'package:newsweb/model/retrive_data.dart';
import 'package:newsweb/model/entity/category.dart';
import 'package:newsweb/view/layout/util.dart';

class FooterPage extends StatefulWidget {
  const FooterPage({super.key});

  @override
  State<FooterPage> createState() => _FooterPageState();
}

class _FooterPageState extends State<FooterPage> {
  late Future<List<Category>> categoriesFuture;

  final int numOfCategories = 4;

  Future<List<Category>> fetchCategories() async 
  {
      try {
          return await RetriveData.sharedInstance.getCategories();
      } catch (e) {
          throw Exception('Failed to load categories: $e');
      }
  }

  @override
  void initState() 
  {
    super.initState();
    categoriesFuture = fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(
      future: categoriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: Colors.black,
            padding: const EdgeInsets.all(16.0),
            child: Util.isLoading(), // Indicatore di caricamento
          );
        }

        if (snapshot.hasError) {
          return Container(
            color: Colors.black,
            padding: const EdgeInsets.all(16.0),
            child: Util.error("Errore nel caricamento delle categorie."),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Container(
            color: Colors.black,
            padding: const EdgeInsets.all(16.0),
            child: Util.error("Nessuna categoria."),
          );
        }

        List<Category> categories = snapshot.data!;

        return Container(
          color: Colors.black,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: numOfCategories,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return GestureDetector(
                    onTap: () {
                      // GOTO
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category.name,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Column(
                            children: category.subcategory
                                .map((sub) => Text(
                                      sub,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    )).toList(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
