import 'package:flutter/material.dart';
import 'package:mobileproject/src/bloc/provider_product.dart';
import 'package:mobileproject/src/models/products.dart';
import 'package:mobileproject/src/models/stores.dart';
import 'package:mobileproject/src/views/home.dart';

class MainlList extends StatelessWidget {
  final Stores store;
  const MainlList({required this.store, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProductProvider(
      child: MaterialApp(
        home: ProductsView(
          store: store,
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class ProductsView extends StatefulWidget {
  final Stores store;
  const ProductsView({required this.store, Key? key}) : super(key: key);
  @override
  _ProductsView createState() => _ProductsView(x: store.storeName);
}

class _ProductsView extends State<ProductsView> {
     var x;

   _ProductsView({required this.x});

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      final bloc = ProductProvider.of(context);
      bloc.getSelectedProducts('getProducts', widget.store.id!);
    });
  }

  @override
  Widget build(BuildContext contex) {
    final productbloc = ProductProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => MainPage()));
            }),
        title: Text("$x: Products"),
        centerTitle: true,
        backgroundColor: Color(0xff001D6E),
      ),
      body: StreamBuilder<List<Products>>(
        stream: productbloc.products,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0)),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 60,
                          height: 60,
                          child: CircleAvatar(
                            backgroundImage:
                                NetworkImage(snapshot.data![index].photo!),
                          ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              children: [
                                Text("Product Name :",
                                    style: TextStyle(
                                        color: Color(0xff001D6E),
                                        fontSize: 18.0)),
                                Text(
                                  snapshot.data![index].productName!,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                              children: [
                                Text("Description :",
                                    style: TextStyle(
                                        color: Color(0xff001D6E),
                                        fontSize: 18.0)),
                                Text(
                                  snapshot.data![index].productDescription!,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text("Price :",
                                    style: TextStyle(
                                        color: Color(0xff001D6E),
                                        fontSize: 18.0)),
                                Text(
                                  snapshot.data![index].price!,
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        )
                      ]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
