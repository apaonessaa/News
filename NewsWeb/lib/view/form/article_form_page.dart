import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:newsweb/model/retrive_data.dart';
import 'package:newsweb/model/send_data.dart';
import 'package:newsweb/model/entity/article.dart';
import 'package:newsweb/model/entity/category.dart';
import 'package:newsweb/view/layout/custom_page.dart';
import 'package:newsweb/view/layout/util.dart';
import 'package:newsweb/view/layout/image_viewer.dart';
import 'package:newsweb/view/layout/article_page/layer.dart';
import 'package:newsweb/view/form/form_utils.dart';

class ArticleFormPage extends StatefulWidget
{
    const ArticleFormPage({super.key});
    @override 
    _ArticleFormPage createState() => _ArticleFormPage();
}

class _ArticleFormPage extends State<ArticleFormPage> 
{    
    List<Category> categories = [];
    bool isLoadingCategory = true;
    bool hasErrorCategory = false;

    late quill.QuillController _titleController;
    late quill.QuillController _abstractController;
    late quill.QuillController _bodyController;

    FilePickerResult? pickedFile;
    Uint8List? imageBytes;
    String? imageFilename;
    bool isLoadingImageUploaded = true;
    bool hasErrorImageUploaded = false;

    Category? selectedCategory;
    Set<String> selectedSubcategories = {};

    bool isSaving = false;

    @override
    void initState() 
    {
        super.initState();
        _titleController = quill.QuillController.basic();
        _abstractController = quill.QuillController.basic(); 
        _bodyController = quill.QuillController.basic(); 
        _loadCategories();
    }

    @override
    void dispose() 
    {
        _titleController.dispose();
        _abstractController.dispose();
        _bodyController.dispose();
        super.dispose();
    }

    void _loadCategories() async 
    {
        setState(() {
            isLoadingCategory = true;
            hasErrorCategory = false;
        });

        try {
            final result = await RetriveData.sharedInstance.getCategories();
            if (mounted && result != null) {
                setState(() {
                    categories = result;
                });
            }
        } catch (error) {
            if (mounted) {
                setState(() {
                    hasErrorCategory = true;
                    Util.notify(context, "Errore con il caricamento delle categorie", true);
                });
            }
        }

        setState(() {
            isLoadingCategory = false;
        });
    }

    void save() async 
    {
        setState(() {
          isSaving = true;
        });

        String _title = _titleController.document.toPlainText()
            .replaceAll(RegExp(r'[^\w\s-]'), '')  // Rimuove tutto tranne lettere, numeri, spazi e trattini
            .replaceAll(RegExp(r'\s+'), ' ')      // Riduce gli spazi consecutivi a uno solo
            .trim();                             // Rimuove gli spazi all'inizio e alla fine
        String _summary = jsonEncode(_abstractController.document.toDelta().toJson());
        String _content = jsonEncode(_bodyController.document.toDelta().toJson());
        if (selectedCategory == null || selectedSubcategories.isEmpty) {
            setState(() {
                isSaving = false;
                Util.notify(context, "Scegli una categoria ed almeno una sotto-categoria.", true);
            });
            return;
        }

        Article art = Article(
            title: _title,
            summary: _summary,
            content: _content,
            category: selectedCategory!.name,
            subcategory: selectedSubcategories.toList(),
            image: 'image',
        );

        if (imageFilename == null || imageBytes == null) {
            setState(() {
                isSaving = false;
                Util.notify(context, "Seleziona un'immagine.", true);
            });
            return;
        }

        try {
            await SendData.sharedInstance.save(art, imageBytes!, imageFilename!);
            setState(() {
                isSaving = false;
            });
            FormUtils.gotoAdminDialog(
                context, 
                "Articolo salvato", 
                "L'articolo è stato salvato ed è disponibile al pubblico.",
                [
                    TextButton(
                        onPressed: () {
                            Navigator.of(context).pop();
                            context.go('/admin'); 
                        },
                        child: Text("Ok"),
                    )
                ]
            );
        } catch (e) {
            setState(() {
                isSaving = false;
                Util.notify(context, "L'articolo non è stato salvato con successo.", true);
            });
        }
    }

    void chooseImage() async 
    {
        setState(() {
            isLoadingImageUploaded = true;
            hasErrorImageUploaded = false;
        });

        try {
            pickedFile = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['jpg', 'png'],
            );
            if (pickedFile != null && pickedFile!.files.isNotEmpty) {
                setState(() {
                    final file = pickedFile!.files.first;
                    imageBytes = file.bytes;
                    imageFilename = file.name;
                    Util.notify(context, "L'immagine è stata caricata con successo!", false);
                });
            } else {
                setState(() {
                    hasErrorImageUploaded = true;
                    Util.notify(context, "Nessuna immagine caricata.", true);
                });
            }
        } catch (e) {
            setState(() {
                hasErrorImageUploaded = true;
                Util.notify(context, "Errore con il caricamento dell'immagine", true);
            });
        } finally {
            setState(() {
                isLoadingImageUploaded = false;
            });
        }
    }

    @override
    Widget build(BuildContext context) 
    {
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
                if (isLoadingCategory || isSaving)
                    Util.isLoading()
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
                        const SizedBox(height: 70),
                        ..._buildSave(),
                    ],
                const SizedBox(height: 100),
            ],
        );
    }

    List<Widget> _titleForm() 
    {
        return [
            const Text(
                'Titolo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
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

    List<Widget> _abstractForm() 
    {
        return [
            const Text(
            'Sintesi',
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
                        multiRowsDisplay: true,
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
                        placeholder: "Inserisci una sintesi...",
                        scrollable: true,
                        expands: false,
                        padding: EdgeInsets.zero,
                        autoFocus: false,
                    ),
                ),
            ),
        ];
    }

    List<Widget> _bodyForm()
    {
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

    List<Widget> _buildImage() 
    {
        return [
            const Text(
                'Immagine',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    /*
                    if (widget.title != null) ...[
                        SizedBox(
                            width: 200,
                            child: ImageViewer(title: widget.title!),
                        ),
                        const SizedBox(width: 10.0),
                    ],
                    */
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

    List<Widget> _buildCategory() 
    {
        return [
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
                            selectedCategory == null 
                                ? Icons.add_circle_outline_rounded 
                                : Icons.change_circle_rounded,
                            color: Colors.red,
                        ),
                        onPressed: () => FormUtils.openFilterDialogCategory(
                            context, 
                            'Seleziona una categoria per l\'articolo.',
                            categories.map((category) {
                                final isSelected = selectedCategory?.name == category.name;
                                return FilterChip(
                                    label: Text(category.name),
                                    selected: isSelected,
                                    selectedColor: Colors.red,
                                    checkmarkColor: Colors.black,
                                    onSelected: (selected) {
                                        setState(() {
                                            selectedCategory = category;
                                            selectedSubcategories = {}; 
                                        });
                                        Navigator.pop(context);
                                    },
                                );
                                }).toList()
                        )                    
                    )
                ],
            ),
            if (selectedCategory != null) ...[
                Center(
                    child: Text(
                        selectedCategory!.name,
                        style: const TextStyle(fontSize: 20, color: Colors.red, fontWeight: FontWeight.w500),
                    ),
                ),
                const SizedBox(height: 20.0),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        const Text(
                            'Sotto-categorie selezionate:',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8.0),
                        IconButton(
                            icon: const Icon(Icons.add_circle_outline_rounded, color: Colors.red),
                            onPressed: () => FormUtils.openFilterDialogSubcategories(
                                context, 
                                'Sotto-categorie di ${selectedCategory!.name}',
                                selectedCategory!.subcategory.map((subcat) {
                                    final isSelected = selectedSubcategories.contains(subcat);
                                    return FilterChip(
                                        label: Text(subcat, style: TextStyle(color: isSelected ? Colors.white : Colors.black, backgroundColor: isSelected ? Colors.red : Colors.white)),
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
                                        },
                                    );
                                }).toList(),
                            ),
                        )
                    ],
                ),
            ],

            const SizedBox(height: 10.0),

            if (selectedSubcategories.isNotEmpty)
                Center(
                    child: Wrap(
                        spacing: 8.0, 
                        runSpacing: 4.0, 
                        children: selectedSubcategories.map((sub) {
                            return Chip(
                                label: Text(sub),
                                backgroundColor: Colors.red.withOpacity(0.1),
                                deleteIcon: const Icon(Icons.close, size: 18, color: Colors.red),
                                onDeleted: () {
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

    List<Widget> _buildSave() 
    {
        return [
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    SizedBox(
                        width: 120,
                        height: 35,
                        child: ElevatedButton(
                            onPressed: save,
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            child: const Text('Salva'),
                        ),
                    ),
                ],
            ),
        ];
    }
}

