import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/stores.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class StoreBloc {
  final _stores = BehaviorSubject<List<Stores>>();
  List<Stores> listStores = [];

  //get data
  Stream<List<Stores>> get stores => _stores.stream;

  void setList(List<Stores> list) {
    listStores = list;
  }

  //set data
  Function(List<Stores>) get changeStores => _stores.sink.add;

  dispose() {
    _stores.close();
  }

  final String _url = 'https://basicmobileapi.herokuapp.com/api/user/';

  Future<void> fetchData(apiUrl) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var x = await _getToken();
    var data = {"token": token};
    var fullUrl = _url + apiUrl + await _getToken();
    var response = await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: _setHeaders());
    var jsonResponse = convert.jsonDecode(response.body);
    var jsonStores = jsonResponse as List;
    List<Stores> store = [];
    // print(jsonUsers);
    jsonStores.forEach((stores) => {store.add(Stores.fromJson(stores))});
    setList(store);
    changeStores(store);
  }

  Future<void> getSearchedStores(apiUrl, productId) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var x = await _getToken();
    var data = {"token": token, "productId": productId};
    var fullUrl = _url + apiUrl + await _getToken();
    var response = await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: _setHeaders());
    var jsonResponse = convert.jsonDecode(response.body);
    var jsonStores = jsonResponse as List;
    List<Stores> store = [];
    // print(jsonUsers);
    jsonStores.forEach((stores) => {store.add(Stores.fromJson(stores))});
    setList(store);
    changeStores(store);
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    return '?token=$token';
  }
}
