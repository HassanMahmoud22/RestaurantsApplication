import 'package:flutter/material.dart';
import 'package:mobileproject/src/bloc/provider_store.dart';
import 'package:mobileproject/src/views/products_view.dart';

import '../models/stores.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      child: const MaterialApp(
        home: HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      final bloc = StoreProvider.of(context);
      bloc.fetchData('getStores');
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = StoreProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Stores"),
        backgroundColor: Color(0xff001D6E),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Stores>>(
        stream: bloc.stores,
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
                                  builder: (context) =>
                                      MainlList(store: snapshot.data![index])));
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
