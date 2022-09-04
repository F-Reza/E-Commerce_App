import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_com_user/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart_provider.dart';
import '../provider/product_provider.dart';
import '../utils/constants.dart';
import '../widgets/main_drawer.dart';
import 'cart_page.dart';

class ProductPage extends StatefulWidget {
  static const String routeName = '/product';

  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int selectedIndex = 0;
  int? chipValue = 0;
  int currentPos = 0;

  @override
  void didChangeDependencies() {
    Provider.of<ProductProvider>(context, listen: false).getAllProducts();
    Provider.of<ProductProvider>(context, listen: false).getAllCategories();
    Provider.of<ProductProvider>(context, listen: false).getAllFeaturedProducts();
    Provider.of<CartProvider>(context, listen: false).getCartByUser();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        title: const Text('Next Digit'),
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, CartPage.routeName);
                  },
                  icon: const Icon(Icons.shopping_cart_outlined)
              ),
              Positioned(
                top: -8,
                left: 18,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.center,
                    width: 15,
                    height: 15,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: FittedBox(
                      child: Consumer<CartProvider>(
                        builder: (context, value, child) => Text('${value.totalItemsInCart}'),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          /*PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  onTap: () async {
                    final navigator = Navigator.of(context);
                    await Future.delayed(Duration.zero);
                    navigator.push(
                      MaterialPageRoute(builder: (_) => const ProfilePage()),
                    );
                  },
                  child: const Text('Profile'),
                ),
                PopupMenuItem(
                  onTap: () async {
                    final navigator = Navigator.of(context);
                    await Future.delayed(Duration.zero);
                    navigator.push(
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                  },
                  child: const Text('Logout'),
                ),
              ]
          ),*/
        ],
      ),
      /*bottomNavigationBar: BottomAppBar(
        child: Consumer<ProductProvider>(
          builder: (context, provider, _) => BottomNavigationBar(
            currentIndex: selectedIndex,
            selectedItemColor: Colors.white,
            backgroundColor: Colors.blue,
            onTap: (value) {
              setState(() {
                selectedIndex = value;
              });
              if (selectedIndex == 0) {
                //provider.getAllContact();
              } else if (selectedIndex == 1) {
                //provider.getAllFavoriteContacts();
              } else if (selectedIndex == 2) {
                //provider.getAllFavoriteContacts();
              }
            },
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.all_inbox), label: 'All Product'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_box), label: 'Cart'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_box), label: 'Profile'),
            ],
          ),
        ),
      ),*/
      body: Consumer<ProductProvider>(
        builder: (context, provider, _) => Column(
          children: [
            SizedBox(
              height: 70,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: provider.categoryNameList.length,
                itemBuilder: (context, index) {
                  final catName = provider.categoryNameList[index];
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ChoiceChip(
                      labelStyle: TextStyle(
                          color:
                              chipValue == index ? Colors.white : Colors.black),
                      selectedColor: Theme.of(context).primaryColor,
                      label: Text(catName),
                      selected: chipValue == index,
                      onSelected: (value) {
                        setState(() {
                          chipValue = value ? index : null;
                        });
                        if (chipValue != null && chipValue != 0) {
                          provider.getAllProductsByCategory(catName);
                        } else if (chipValue == 0) {
                          provider.getAllProducts();
                        }
                      },
                    ),
                  );
                },
              ),
            ),
            const Divider(
              height: 1,
            ),
            InkWell(
              //
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 140.0,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.6,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentPos = index;
                    });
                  },
                  scrollDirection: Axis.horizontal,
                ),
                items: provider.featuredProductList
                    .map((product) => Container(
                  color: Colors.blue,
                          width: 200,
                          padding: const EdgeInsets.all(1),
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Stack(
                            children: [
                              FadeInImage.assetNetwork(
                                placeholder: 'images/placeholder.jpg',
                                image: product.imageUrl!,
                                fadeInDuration: const Duration(seconds: 2),
                                fadeInCurve: Curves.bounceInOut,
                                width: double.maxFinite,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  height: 40,
                                  color: Colors.black45,
                                  alignment: Alignment.center,
                                  child: Text(
                                    product.name!,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Container(
                                  height: 16,
                                  color: Colors.red,
                                  alignment: Alignment.center,
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(
                                      'New',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 30,
                                right: 0,
                                child: Container(
                                  height: 20,
                                  color: Colors.white70,
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(
                                      '$currencySymbol${product.salesPrice.toString()}',
                                      style: const TextStyle(fontSize: 18, color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: provider.featuredProductList.map((url) {
                int index = provider.featuredProductList.indexOf(url);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentPos == index
                        ? const Color.fromRGBO(0, 0, 0, 0.9)
                        : const Color.fromRGBO(0, 0, 0, 0.4),
                  ),
                );
              }).toList(),
            ),
            provider.productList.isEmpty
                ? const Center(child: Text('No item found!', style: TextStyle(fontSize: 18),),) :
                //const Text('Featured Products', textAlign: TextAlign.left,style: TextStyle(fontSize: 18,),),
                Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                        childAspectRatio: 0.6,
                      ),
                      itemCount: provider.productList.length,
                      itemBuilder: (context, index) {
                        final product = provider.productList[index];
                        return Card(
                            elevation: 5,
                            child: ProductItem(
                              productModel: product,
                            ));
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
