import 'package:flutter/material.dart';
import 'package:mobileproject/src/bloc/store_bloc.dart';


class StoreProvider extends InheritedWidget {
  final StoreBloc bloc;

  StoreProvider({Key? key, Widget? child})
      : bloc = StoreBloc(),
        super(key: key, child: child!);
  @override
  bool updateShouldNotify(_) => true;


  static StoreBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<StoreProvider>()
        as StoreProvider).bloc;
  }
}
