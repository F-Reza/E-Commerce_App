
import 'package:e_com_admin/models/category_model.dart';
import 'package:e_com_admin/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class CategoryPage extends StatefulWidget {
  static const String routeName = '/category';
  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
  @override

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: const MainDrawer(),
      appBar: AppBar(
        title: const Text('Categories'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                showDialog(context: context, builder: (context) => AlertDialog(
                  title: const Text('ADD CATEGORY'),
                  content: Form(
                    key: formKey,
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: nameController,
                      decoration: const InputDecoration(
                        hintText: 'Enter new Category...',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Can\'t be empty!';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  actions: [
                    TextButton(onPressed: () {
                      Navigator.pop(context);
                      nameController.clear();
                    },
                      child: const Text('CANCEL'),
                    ),
                    TextButton(
                      onPressed: () async {
                        if(formKey.currentState!.validate()) {
                          await Provider.of<ProductProvider>(context, listen: false)
                              .addCategory(nameController.text);
                          nameController.clear();
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('ADD'),
                    ),
                  ],
                ));
              },
              icon: const Icon(Icons.add_box_rounded,size: 30,),
          ),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, _) =>
        provider.categoryList.isEmpty ?
        const Center(child: Text('No item found!', style: TextStyle(fontSize: 18),),) :
        ListView.builder(
          itemCount: provider.categoryList.length,
          itemBuilder: (context, index) {
            final category = provider.categoryList[index];
            return Card(
              elevation: 5,
              child: ListTile(
                title: Text('${index+1}  ${category.catName} (${category.productCount})'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(onPressed: () {
                      showInputDialog(
                          title: 'Update Category',
                          value: category.catName,
                          onSaved: (value) {
                            provider.updateCategory(
                                category.catId!,
                                {'name' : value});
                          });
                    }, icon: const Icon(Icons.edit)),
                    IconButton(onPressed: () {
                      showDialog(context: context, builder: (context) => AlertDialog(
                        title: const Text('Are you sure delete this category ?',
                          style: TextStyle(color: Colors.redAccent),),
                        content: Text('${category.catName}',
                          style: const TextStyle(fontSize: 16, color: Colors.blueAccent),),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context),
                            child: const Text('NO'),
                          ),
                          TextButton(
                            onPressed: () async {
                              await Provider.of<ProductProvider>(context, listen: false)
                              .deleteCategory(category.catId!, {'id' : categoryId});
                              Navigator.pop(context);
                            },
                            child: const Text('YES'),
                          ),
                        ],
                      ));
                    }, icon: const Icon(Icons.delete)),

                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }


  showInputDialog({
    required String title,
    String? value,
    required Function(String) onSaved}) {
    final textController =TextEditingController();
    textController.text = value ?? '';
    showDialog(context: context, builder: (context) => AlertDialog(
      title: Text(title),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: TextFormField(
            controller: textController,
            decoration: InputDecoration(
                hintText: 'Enter $title',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Can\'t be empty!';
              } else {
                return null;
              }
            },
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context),
          child: const Text('CANCEL'),
        ),
        TextButton(
          onPressed: () async {
            if(formKey.currentState!.validate()) {
              await onSaved(textController.text);
              Navigator.pop(context);
            }
          },
          child: const Text('UPDATE'),
        ),
      ],
    ));
  }
}
