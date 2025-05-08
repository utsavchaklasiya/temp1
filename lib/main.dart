import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyShopApp());
}

class MyShopApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Shop',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ShopHomePage(),
    );
  }
}

class Item {
  final String name;
  final double price;
  final String imageUrl;

  Item({required this.name, required this.price, required this.imageUrl});
}

class ShopHomePage extends StatefulWidget {
  @override
  _ShopHomePageState createState() => _ShopHomePageState();
}

class _ShopHomePageState extends State<ShopHomePage> {
  List<Item> items = [
    Item(
        name: "Apples",
        price: 2.5,
        imageUrl:
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR1tMJ1wEPJU57-M-FDjXd4NzoJBC6uOKNKBw&s"),
    Item(
        name: "Bananas",
        price: 1.8,
        imageUrl:
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ6q-DAB6iOMYjtfZtxqt2BgFAT21JjMQ2JKw&s"),
    Item(
        name: "Oranges",
        price: 3.0,
        imageUrl:
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQEZeYvkPorIuW7yfCQQ-cM_I0L0UbP0gOMyA&s"),
    Item(
        name: "Milk",
        price: 4.0,
        imageUrl:
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTA-z88kFeAZDmn7ziYvQANpBwHHU90gk8OMA&s"),
    Item(
        name: "Bread",
        price: 2.0,
        imageUrl:
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSD8ixgTKQe1GkKbxhuA_UnjZMNd3PUVtMhAQ&s"),
  ];

  List<Item> cart = [];

  void addToCart(Item item) {
    setState(() {
      cart.add(item);
    });
  }

  void removeFromCart(int index, BuildContext bottomSheetContext) {
    setState(() {
      cart.removeAt(index);
    });

    if (cart.isEmpty) {
      Navigator.pop(bottomSheetContext);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("All items removed successfully.")),
      );
    }
  }

  void clearCart() {
    setState(() {
      cart.clear();
    });
  }

  double getTotal() {
    return cart.fold(0, (sum, item) => sum + item.price);
  }

  @override
  Widget build(BuildContext context) {
    final bool isWeb = kIsWeb;

    return Scaffold(
      appBar: AppBar(
        title: Text("Shop App"),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_bag),
            onPressed: () => _showCart(context),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isWeb ? 3 : 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: isWeb ? 0.7 : 0.8,
          ),
          itemBuilder: (context, index) {
            final item = items[index];
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  isWeb
                      ? SizedBox(
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(10)),
                      child: Image.network(
                        item.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                      : Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(10)),
                      child: Image.network(
                        item.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(item.name,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Text("\$${item.price.toStringAsFixed(2)}"),
                        SizedBox(height: 6),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () => addToCart(item),
                            child: Text("Add"),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showCart(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (bottomSheetContext) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            padding: EdgeInsets.all(16),
            height: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Shopping Bag",
                    style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Divider(),
                Expanded(
                  child: cart.isEmpty
                      ? Center(child: Text("Your cart is empty"))
                      : ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final item = cart[index];
                      return ListTile(
                        title: Text(item.name),
                        subtitle: Text(
                            "\$${item.price.toStringAsFixed(2)}"),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => removeFromCart(
                              index, bottomSheetContext),
                        ),
                      );
                    },
                  ),
                ),
                Divider(),
                Text("Total: \$${getTotal().toStringAsFixed(2)}",
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed:
                    cart.isEmpty ? null : () => _checkout(context),
                    child: Text("Checkout"),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _checkout(BuildContext context) {
    Navigator.pop(context); // Close bottom sheet first
    clearCart();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Order Placed"),
        content: Text("Your order has been placed successfully."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          )
        ],
      ),
    );
  }
}
