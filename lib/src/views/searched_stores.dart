import 'package:flutter/material.dart';
import 'package:mobileproject/src/bloc/provider_store.dart';
import 'package:mobileproject/src/models/products.dart';
import 'package:mobileproject/src/models/stores.dart';
import 'package:mobileproject/src/views/view_all_on_map.dart';

import 'SpecificMap.dart';
import 'all_products.dart';

class mainSearchedStores extends StatelessWidget {
  final Products product;
  const mainSearchedStores({required this.product, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      child: MaterialApp(
        title: "Bloc APP",
        home: SearchedStoresView(product: product),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class SearchedStoresView extends StatefulWidget {
  final Products product;
  const SearchedStoresView({required this.product, Key? key}) : super(key: key);
  @override
  _SearchedStoresView createState() => _SearchedStoresView(x: product);
}

class _SearchedStoresView extends State<SearchedStoresView> {
  final Products x;
  _SearchedStoresView({required this.x});

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      final bloc = StoreProvider.of(context);
      bloc.getSearchedStores('getSearchedStores', widget.product.id!);
    });
  }

  @override
  Widget build(BuildContext contex) {
    final storebloc = StoreProvider.of(context);
    var ProductName = x.productName;
    return Scaffold(
      appBar: AppBar(
       actions: [
          IconButton(
              icon: Icon(Icons.location_on),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewAllOnMap(stores: storebloc.listStores)));
              }),
          // add more IconButton
        ],
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => MainAllProducts()));
            }),
        title: Text(
          "Stores have :$ProductName",
          style: const TextStyle(fontSize: 15),
        ),
        backgroundColor: Color(0xff001D6E),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Stores>>(
        stream: storebloc.stores,
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
                                Text("Store Name :",
                                    style: TextStyle(
                                        color: Color(0xff001D6E),
                                        fontSize: 18.0)),
                                Text(
                                  snapshot.data![index].storeName!,
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
                                  snapshot.data![index].description!,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text("View on Map",
                                    style: TextStyle(
                                      color: Color(0xff001D6E),
                                      fontWeight: FontWeight.bold,
                                    )),
                                SizedBox(
                                  width: 5,
                                ),
                                _viewOnMap(store: snapshot.data![index])
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

class _viewOnMap extends StatelessWidget {
  final Stores store;
  const _viewOnMap({required this.store, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.location_on),
        onPressed: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => SpecificMap(store:store)));
        });
  }
}
