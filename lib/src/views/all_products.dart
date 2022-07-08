import 'package:flutter/material.dart';
import 'package:mobileproject/src/bloc/provider_product.dart';
import 'package:mobileproject/src/models/products.dart';
import 'package:mobileproject/src/views/searched_stores.dart';
import 'home.dart';

class MainAllProducts extends StatelessWidget {
  const MainAllProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProductProvider(
      child: MaterialApp(
        home: AllProducts(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AllProducts extends StatefulWidget {
  const AllProducts({Key? key}) : super(key: key);
  @override
  _AllProducts createState() => _AllProducts();
}

class _AllProducts extends State<AllProducts> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      final bloc = ProductProvider.of(context);
      bloc.getAllProducts('getAllProducts');
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = ProductProvider.of(context);
    return Scaffold(
       appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => MainPage()));
            }),
          title: const Text("All Products"),
          backgroundColor: Color(0xff001D6E),
          centerTitle: true,
      ),
      body: StreamBuilder<List<Products>>(
        stream: bloc.products,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Column(
                children: <Widget>[
                  Card(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0)),
                      child: new InkWell(
                       onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => mainSearchedStores(
                                    product: snapshot.data![index])));
                      },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 60,
                                  height: 60,
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        snapshot.data![index].photo!),
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
                                    SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                )
                              ]),
                        ),
                      )),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
