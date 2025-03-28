import 'package:flutter/material.dart';
import 'package:my_app/db_helper.dart';
// ignore: unused_import
import 'result_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> products = [];
  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final dbProducts = await DbHelper.fetchProducts();
    setState(() {
      products = dbProducts;
    });
    if (products.isEmpty) {
      await _insertDefaultProducts();
      _loadProducts();
    }
  }

  Future<void> _insertDefaultProducts() async {
    List<Map<String, dynamic>> defaultProducts = [
      {
        "name": "Chaussure Nikes",
        "image": "assets/nike.png",
        "price": "59.99Euro",
        "description": "Des chaussures confortables et légères",
      },
      {
        "name": "Montre Rolex",
        "image": "assets/rolex.png",
        "price": "999.99Euro",
        "description": "Montre élégante pour toutes occasions.",
      },
      {
        "name": "Casques Bluetooth",
        "image": "assets/casque.png",
        "price": "79.99Euro",
        "description": "Un son immersif avec réduction de bruit.",
      },
      {
        "name": "Les vêtements pour homme ",
        "image": "assets/habit_homme.png",
        "price": "20.99Euro",
        "description": "Nos vêtements sont de hautes gammes et de qualités.",
      },
      {
        "name": "Les vêtements pour femme ",
        "image": "assets/habit_femme.png",
        "price": "30.99Euro",
        "description": "Nos vêtements sont de hautes gammes et de qualités.",
      },
    ];
    for (var product in defaultProducts) {
      await DbHelper.insertProduct(product);
    }
  }

  String searchQuery = "";
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredProducts =
        products.where((product) {
          return product['name'].toLowerCase().contains(
            searchQuery.toLowerCase(),
          );
        }).toList();
        return Scaffold(
        appBar: AppBar(title: const Text("E-Shop"), backgroundColor: Colors.blueAccent),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Rechercher un produit...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          // Bannière produit mis en avant
          Container(
            margin: const EdgeInsets.all(10),
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: const DecorationImage(
                image: AssetImage("assets/beau.png"),
                fit: BoxFit.cover,
              ),
            ),
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.all(10),
            child: const Text(
              "Produit en vedette",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Liste des produits
          Expanded(
            child: ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: Image.asset(
                      product["image"],
                      width: 50,
                      height: 50,
                    ),
                    title: Text(product["name"]),
                    subtitle: Text(product["description"]),
                    trailing: Text(
                      product["price"],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}