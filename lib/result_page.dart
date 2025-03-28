import 'package:flutter/material.dart';
import 'package:my_app/db_helper.dart';

class ResultPage extends StatefulWidget {
  final String query;
  const ResultPage({super.key, required this.query});
  @override
  // ignore: library_private_types_in_public_api
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  List<Map<String, dynamic>> searchResults = [];
  @override
  void initState() {
    super.initState();
    _searchProducts();
  }

  Future<void> _searchProducts() async {
    final allProducts = await DbHelper.fetchProducts();
    setState(() {
      searchResults =
          allProducts.where((product) {
            return product['name'].toLowerCase().contains(
              widget.query.toLowerCase(),
            );
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Résultats pour '${widget.query}'")),
      body: ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          final product = searchResults[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: Image.asset(product["image"], width: 50, height: 50),
              title: Text(product["name"]),
              subtitle: Text(product["description"]),
              trailing: Text(
                product["price"],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
