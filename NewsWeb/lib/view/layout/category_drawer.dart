import 'package:flutter/material.dart';
import 'package:newsweb/model/retrive_data.dart';
import 'package:newsweb/model/entity/category.dart';
import 'package:newsweb/view/layout/util.dart';

class CategoryDrawer extends StatefulWidget {
  const CategoryDrawer({super.key});
  @override
  State<CategoryDrawer> createState() => _CategoryDrawer();
}

class _CategoryDrawer extends State<CategoryDrawer> {
  late Future<List<Category>> categoriesFuture;
  int? selectedCategoryIndex;

  final int numOfCategories = 4;

  Future<List<Category>> fetchCategories() async {
    try {
      return await RetriveData.sharedInstance.getCategories();
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }

  @override
  void initState() {
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
            child: Util.isLoading(),
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

        return Drawer(
          child: Container(
            color: Colors.black,
            child: ListView(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return ExpansionTile(
                      tilePadding: EdgeInsets.symmetric(horizontal: 16.0),
                      title: Text(
                        categories[index].name,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      children: [
                        if (selectedCategoryIndex == index)
                          ...categories[index].subcategory.map((subcategory) {
                            return ListTile(
                              title: Text(
                                subcategory,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }).toList(),
                      ],
                      onExpansionChanged: (bool expanded) {
                        setState(() {
                          if (expanded) {
                            selectedCategoryIndex = index;
                          } else {
                            if (selectedCategoryIndex == index) {
                              selectedCategoryIndex = null;
                            }
                          }
                        });
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
