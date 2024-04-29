import 'package:bluetooth_printer/print_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final List<Map<String, dynamic>> productList = [
    {'title': 'Cadbury Dairy Milk', 'price': 15, 'qty': 2},
    {'title': 'Parle-G Gluco Biscut', 'price': 5, 'qty': 5},
    {'title': 'Fresh Onion - 1KG', 'price': 20, 'qty': 1},
    {'title': 'Fresh Sweet Lime', 'price': 20, 'qty': 5},
    {'title': 'Maggi', 'price': 10, 'qty': 5},
  ];

  final f = NumberFormat("\$###,###.00", "en-us");

  @override
  Widget build(BuildContext context) {
    int _total = 0;

    _total = productList
        .map((e) => e['price'] * e['qty'])
        .reduce((value, element) => value + element);

    return Scaffold(
        appBar: AppBar(
          title: Text('Anil'),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: productList.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(
                    productList[index]['title'],
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                      "${f.format(productList[index]['price'])} X ${productList[index]['qty']}"),
                  trailing: Text(
                      "${f.format(productList[index]['price'] * productList[index]['qty'])}"),
                ),
              ),
            ),
            Container(
              color: Colors.grey[400],
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${f.format(_total)}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(
                    width: 80,
                  ),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PrintPage(
                                      purchasedList: productList,
                                    )));
                      },
                      icon: Icon(Icons.print),
                      label: Text('Printer'),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
