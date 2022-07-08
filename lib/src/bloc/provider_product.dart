import 'package:flutter/material.dart';
import 'package:mobileproject/src/bloc/product_bloc.dart';

class ProductProvider extends InheritedWidget {
  final ProductBloc bloc;

  ProductProvider({Key? key, Widget? child})
      : bloc = ProductBloc(),
        super(key: key, child: child!);
  @override
  bool updateShouldNotify(_) => true;


  static ProductBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProductProvider>()
        as ProductProvider).bloc;
  }
}
