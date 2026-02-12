import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:newsweb/model/retrive_data.dart';
import 'package:newsweb/model/entity/article.dart';
import 'package:newsweb/model/entity/category.dart';
import 'package:newsweb/view/layout/custom_page.dart';
import 'package:newsweb/view/layout/util.dart';
import 'package:newsweb/view/layout/image_viewer.dart';
import 'package:newsweb/view/layout/article_page/layer.dart';
import 'dart:convert';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:collection/collection.dart';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';

class ArticleFormPage extends StatefulWidget {
  final String? title;
  const ArticleFormPage({super.key, this.title});
  
  @override 
  _ArticleFormPage createState() => _ArticleFormPage();
}

class _ArticleFormPage extends State<ArticleFormPage> {
  Article? article;
  bool isLoading = true;
  bool hasError = false;

  List<Category> categories = [];
  bool isLoadingCategory = true;
  bool hasErrorCategory = false;

  late quill.QuillController _titleController;
  late quill.QuillController _abstractController;
  late quill.QuillController _bodyController;

  FilePickerResult? pickedFile;
  Uint8List? imageBytes;
  bool isLoadingImageUploaded = true;
  bool hasErrorImageUploaded = false;

  Category? selectedCategory;
  List<String> selectedSubcategories = [];

  @override
  void initState() {
    super.initState();
    _titleController = quill.QuillController.basic();
    _abstractController = quill.QuillController.basic(); 
    _bodyController = quill.QuillController.basic(); 
    _loadCategories();
    _loadArticle();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _abstractController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _loadArticle() async {
    if (widget.title != null) {
      try {
        final result = await RetriveData.sharedInstance.getArticle(widget.title!);
        if (mounted) {
          setState(() {
            if (result != null) {
              article = result;
              _titleController = FormUtils._initController(article?.title);
              _abstractController = FormUtils._initController(article?.summary);
              _bodyController = FormUtils._initController(article?.content);
              selectedCategory = categories.firstWhereOrNull((c) => c.name == result.category);
              selectedSubcategories = result.subcategory;
            }
            isLoading = false;
          });
        }
      } catch (error) {
        if (mounted) {
          setState(() {
            hasError = true;
            isLoading = false;
          });
        }
      }
    } else {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _loadCategories() async {
    try {
      final result = await RetriveData.sharedInstance.getCategories();
      if (mounted && result != null) {
        setState(() {
          categories = result;
          isLoadingCategory = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          hasErrorCategory = true;
          isLoadingCategory = false;
        });
      }
    }
  } 

  @override
  Widget build(BuildContext context) {
    return CustomPage(
      actions: [
        Util.btn(
          Icons.home,
          'Home',
          () => context.go('/'),
        ),
      ],
      content: [
        const SizedBox(height: 40.0),
        if (isLoading)
          Util.isLoading()
        else if (hasError)
          Util.error("Errore nel caricamento dell'articolo.")
        else
          ...[
                ..._titleForm(),
                const SizedBox(height: 30),
                ..._abstractForm(),
                const SizedBox(height: 30),
                ..._bodyForm(),
                const SizedBox(height: 30),
                ..._buildImage(),
                const SizedBox(height: 30),
                ..._buildCategory(),
            ],
        const SizedBox(height: 100),
      ],
    );
  }

    List<Widget> _titleForm() {
        return [
            const Text(
                'Titolo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                ),
                child: quill.QuillSimpleToolbar(
                    controller: _titleController,
                    config: const quill.QuillSimpleToolbarConfig(
                        showFontFamily: false,
                        showFontSize: false,
                        showBoldButton: true,
                        showItalicButton: true,
                        showUnderLineButton: true,
                        showStrikeThrough: true,
                        showColorButton: false,
                        showBackgroundColorButton: false,
                        showListNumbers: false,
                        showListBullets: false,
                        showListCheck: false,
                        showCodeBlock: false,
                        showQuote: false,
                        showIndent: false,
                        showLink: false,
                        showDirection: false,
                        showSearchButton: false,
                        showSubscript: false,
                        showSuperscript: false,
                        multiRowsDisplay: false,
                    ),
                ),
            ),
            Container(
                constraints: const BoxConstraints(minHeight: 100),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
                    color: Colors.white,
                ),
                child: quill.QuillEditor.basic(
                    controller: _titleController,
                    config: const quill.QuillEditorConfig(
                        placeholder: "Inserisci il titolo...",
                        scrollable: false,
                        expands: false,
                        padding: EdgeInsets.zero,
                        autoFocus: false,
                    ),
                ),
            ),
        ];
    }    
    
    List<Widget> _abstractForm() {
        return [
            const Text(
                'Abstract',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                ),
                child: quill.QuillSimpleToolbar(
                    controller: _abstractController,
                    config: const quill.QuillSimpleToolbarConfig(
                        showFontFamily: false,
                        showFontSize: false,
                        showBoldButton: true,
                        showItalicButton: true,
                        showUnderLineButton: true,
                        showStrikeThrough: true,
                        showColorButton: false,
                        showBackgroundColorButton: false,
                        showListNumbers: true,
                        showListBullets: true,
                        showListCheck: true,
                        showCodeBlock: true,
                        showQuote: true,
                        showIndent: true,
                        showLink: false,
                        showDirection: false,
                        showSearchButton: false,
                        showSubscript: false,
                        showSuperscript: false,
                        multiRowsDisplay: false,
                    ),
                ),
            ),
            Container(
                constraints: const BoxConstraints(minHeight: 100),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
                    color: Colors.white,
                ),
                child: quill.QuillEditor.basic(
                    controller: _abstractController,
                    config: const quill.QuillEditorConfig(
                        placeholder: "Inserisci l'abstract...",
                        scrollable: true,
                        expands: false,
                        padding: EdgeInsets.zero,
                        autoFocus: false,
                    ),
                ),
            ),
        ];
    }

    List<Widget> _bodyForm() {
        return [
            const Text(
                'Contenuto',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                ),
                child: quill.QuillSimpleToolbar(
                    controller: _bodyController,
                    config: const quill.QuillSimpleToolbarConfig(
                        showFontFamily: false,
                        showFontSize: false,
                        showBoldButton: true,
                        showItalicButton: true,
                        showUnderLineButton: true,
                        showStrikeThrough: true,
                        showColorButton: false,
                        showBackgroundColorButton: false,
                        showListNumbers: true,
                        showListBullets: true,
                        showListCheck: true,
                        showCodeBlock: true,
                        showQuote: true,
                        showIndent: true,
                        showLink: true,
                        showDirection: false,
                        showSearchButton: false,
                        showSubscript: false,
                        showSuperscript: false,
                        multiRowsDisplay: false,
                    ),
                ),
            ),
            Container(
                constraints: const BoxConstraints(minHeight: 100),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
                    color: Colors.white,
                ),
                child: quill.QuillEditor.basic(
                    controller: _bodyController,
                    config: const quill.QuillEditorConfig(
                        placeholder: "Inserisci il contenuto...",
                        scrollable: true,
                        expands: false,
                        padding: EdgeInsets.zero,
                        autoFocus: false,
                    ),
                ),
            ),
        ];
    }

    List<Widget> _buildImage() {
      return [
        const Text(
            'Immagine',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.title != null) ...[
              SizedBox(
                width: 200,
                child: ImageViewer(title: widget.title!),
              ),
              const SizedBox(width: 10.0),
            ],
            Center(
              child: imageBytes == null
                  ? const Icon(Icons.image, size: 200, color: Colors.grey)
                  : ClipRRect(
                      child: Image.memory(
                        imageBytes!, 
                        height: 200,
                        width: 200, 
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
          ],
        ),
        
        const SizedBox(height: 10.0),
        Center(
          child: SizedBox(
            width: 120,
            height: 30,
            child: ElevatedButton(
              onPressed: chooseImage,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                textStyle: const TextStyle(fontSize: 11),
              ),
              child: const Text('Carica immagine'),
            ),
          ),
        ),
      ];
    }

    void chooseImage() async {
      setState(() {
        isLoadingImageUploaded = true;
        hasErrorImageUploaded = false;
      });

      try {
        pickedFile = await FilePicker.platform.pickFiles();
        if (pickedFile != null && pickedFile!.files.isNotEmpty) {
          setState(() {
            imageBytes = pickedFile!.files.first.bytes;
          });
        } else {
          setState(() {
            hasErrorImageUploaded = true;
          });
        }
      } catch (e) {
        setState(() {
          hasErrorImageUploaded = true;
        });
        print("Errore durante il caricamento dell'immagine: $e");
      } finally {
        setState(() {
          isLoadingImageUploaded = false;
        });
      }
    }

    List<Widget> _buildCategory() {
      return [
        // Sezione Selezione Categoria
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              selectedCategory == null ? 'Seleziona una categoria' : 'Categoria selezionata:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8.0),
            IconButton(
              icon: Icon(
                selectedCategory == null ? Icons.add_circle_outline_rounded : Icons.change_circle_rounded,
                color: Colors.red,
              ),
              onPressed: () => openFilterDialogCategory(),
            )
          ],
        ),

        // Display Nome Categoria
        if (selectedCategory != null) ...[
          Center(
            child: Text(
              selectedCategory!.name, // Usato ! perché abbiamo controllato che non sia null
              style: const TextStyle(fontSize: 20, color: Colors.red, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 20.0),

          // Sezione Selezione Sotto-categorie
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Sotto-categorie',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8.0),
              IconButton(
                icon: const Icon(Icons.add_circle_outline_rounded, color: Colors.red),
                onPressed: () => openFilterDialogSubcategories(),
              )
            ],
          ),
        ],

        const SizedBox(height: 10.0),

        // Visualizzazione Subcategories tramite Chip
        if (selectedSubcategories.isNotEmpty)
          Center(
            child: Wrap(
              spacing: 8.0, // Spazio orizzontale tra i chip
              runSpacing: 4.0, // Spazio verticale tra le righe
              children: selectedSubcategories.map((sub) {
                return Chip(
                  label: Text(sub),
                  backgroundColor: Colors.red.withOpacity(0.1),
                  deleteIcon: const Icon(Icons.close, size: 18, color: Colors.red),
                  onDeleted: () {
                    // Logica opzionale per rimuovere la subcategory direttamente dal chip
                    setState(() {
                      selectedSubcategories.remove(sub);
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Colors.red),
                  ),
                );
              }).toList(),
            ),
          ),
      ];
    }

    void openFilterDialogCategory() async {
      await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder( 
            builder: (context, setDialogState) {
              return AlertDialog(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                titlePadding: EdgeInsets.zero,
                title: _buildDialogHeader('Seleziona la categoria'),
                content: SingleChildScrollView(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 8.0,
                    children: categories.map((category) {
                      final isSelected = selectedCategory?.name == category.name;
                      return FilterChip(
                        label: Text(category.name, style: TextStyle(color: isSelected ? Colors.black : Colors.white)),
                        selected: isSelected,
                        selectedColor: Colors.red,
                        checkmarkColor: Colors.black,
                        onSelected: (selected) {
                          setState(() {
                            selectedCategory = category;
                            selectedSubcategories = []; 
                          });
                          setDialogState(() {});
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          );
        },
      );
    }

    void openFilterDialogSubcategories() async {
      if (selectedCategory == null) {
        return;
      }

      await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                titlePadding: EdgeInsets.zero,
                title: _buildDialogHeader('Sotto-categorie di ${selectedCategory!.name}'),
                content: SingleChildScrollView(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 8.0,
                    children: selectedCategory!.subcategory.map((subcat) {
                      final isSelected = selectedSubcategories.contains(subcat);
                      return FilterChip(
                        label: Text(subcat, style: TextStyle(color: isSelected ? Colors.black : Colors.white)),
                        selected: isSelected,
                        selectedColor: Colors.red,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              selectedSubcategories.add(subcat);
                            } else {
                              selectedSubcategories.remove(subcat);
                            }
                          });
                          setDialogState(() {});
                        },
                      );
                    }).toList(),
                  ),
                ),
                actions: [
                  TextButton(
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Ok'),
                  ),
                ],
              );
            },
          );
        },
      );
    }

    Widget _buildDialogHeader(String title) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16))),
            const Icon(Icons.category, color: Colors.white),
          ],
        ),
      );
    }
}

class FormUtils {
    static quill.QuillController _initController(String? value) {
        if (value == null || value.isEmpty) {
        return quill.QuillController.basic();
        }
        try {
        final decoded = jsonDecode(value);
        return quill.QuillController(
            document: quill.Document.fromJson(decoded),
            selection: const TextSelection.collapsed(offset: 0),
        );
        } catch (e) {
        // Fallback in caso il titolo non sia in formato JSON (Delta)
        return quill.QuillController(
            document: quill.Document()..insert(0, value),
            selection: const TextSelection.collapsed(offset: 0),
        );
        }
    }
}