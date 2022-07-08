import 'dart:convert';

import 'package:mobileproject/src/models/products.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class ProductBloc {
  final _products = BehaviorSubject<List<Products>>();

  //get data
  Stream<List<Products>> get products => _products.stream;
  //set data
  Function(List<Products>) get changeProducts => _products.sink.add;

  dispose() {
    _products.close();
  }

  final String _url = 'https://basicmobileapi.herokuapp.com/api/user/';

  Future<void> getSelectedProducts(apiUrl, storeId) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var x = await _getToken();
    var data = {"token": token, "storeId": storeId};
    var fullUrl = _url + apiUrl + await _getToken();
    var response = await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: _setHeaders());
    var jsonResponse = convert.jsonDecode(response.body);
    print("response");
    print(jsonResponse.toString());
    var jsonProducts = jsonResponse as List;
    List<Products> product = [];
    // print(jsonUsers);
    jsonProducts
        .forEach((products) => {product.add(Products.fromJson(products))});
    print(product);
    changeProducts(product);
  }

   Future<void> getAllProducts(apiUrl) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var x = await _getToken();
    var data = {"token": token};
    var fullUrl = _url + apiUrl + await _getToken();
    var response = await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: _setHeaders());
    var jsonResponse = convert.jsonDecode(response.body);
    print("response");
    print(jsonResponse.toString());
    var jsonProducts = jsonResponse as List;
    List<Products> product = [];
    // print(jsonUsers);
    jsonProducts
        .forEach((products) => {product.add(Products.fromJson(products))});
    print(product);
    changeProducts(product);
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
