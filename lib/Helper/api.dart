import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = 'http://test.zala.bt/api/v1';
  var token;

  _getToken() async {
    SharedPreferences localstorage = await SharedPreferences.getInstance();
    token = jsonDecode(localstorage.getString('token') ?? '');
  }

// Auth APIs
  login(data) async {
    return await http.post(Uri.parse('$baseUrl/login'),
        body: data, headers: _setLoginHeaders());
  }

  register(data) async {
    return await http.post(Uri.parse('$baseUrl/register'),
        body: data, headers: _setLoginHeaders());
  }

  logout() async {
    return await http.post(Uri.parse('$baseUrl/logout'),
        headers: _setLoginHeaders());
  }

  updateProfile(data) async {
    return await http.post(Uri.parse('$baseUrl/update-profile'),
        body: data, headers: _setHeaders());
  }

  // Products APIs
  Future gethomeProducts() async {
    await _getToken();
    final response = await http.get(Uri.parse('$baseUrl/products/home'),
        headers: _setHeaders());
    return response;
  }

  Future getProductDetail(id) async {
    await _getToken();
    final response = await http.get(Uri.parse('$baseUrl/products/details/$id'),
        headers: _setHeaders());
    return response;
  }

  Future searchProducts(data) async {
    await _getToken();
    final response = await http.post(Uri.parse('$baseUrl/products/search'),
        body: data, headers: _setHeaders());
    return response;
  }

  Future searchProductsbyFilter(data, id) async {
    await _getToken();
    final response = await http.post(
        Uri.parse('$baseUrl/products/search?$data=$id'),
        headers: _setHeaders());
    return response;
  }

  Future getFilters() async {
    await _getToken();
    final response = await http.get(Uri.parse('$baseUrl/products/filters'),
        headers: _setHeaders());
    return response;
  }

  Future getSearchHistory() async {
    await _getToken();
    final response = await http.get(Uri.parse('$baseUrl/products/suggestions'),
        headers: _setHeaders());
    return response;
  }

  Future getCategories() async {
    await _getToken();
    final response = await http.get(Uri.parse('$baseUrl/categoreis'),
        headers: _setHeaders());
    return response;
  }

  Future getBrands() async {
    await _getToken();
    final response =
        await http.get(Uri.parse('$baseUrl/brands'), headers: _setHeaders());
    return response;
  }

  // Cart APIs
  Future getCartItems() async {
    await _getToken();
    final response =
        await http.get(Uri.parse('$baseUrl/cart'), headers: _setHeaders());
    return response;
  }

  additemToCart(data) async {
    await _getToken();
    return await http.post(Uri.parse('$baseUrl/cart'),
        body: data, headers: _setHeaders());
  }

  removeitemFromCart(id) async {
    await _getToken();
    return await http.delete(Uri.parse('$baseUrl/cart/$id'),
        headers: _setHeaders());
  }

  updateitemInCart(data, id) async {
    await _getToken();
    return await http.post(Uri.parse('$baseUrl/cart/$id'),
        body: data, headers: _setHeaders());
  }

  clearCart() async {
    await _getToken();
    return await http.delete(Uri.parse('$baseUrl/cart'),
        headers: _setHeaders());
  }

  Future getCartCount() async {
    await _getToken();
    final response = await http.get(Uri.parse('$baseUrl/carts/count'),
        headers: _setHeaders());
    return response;
  }

  // Orders APIs
  Future getOrders() async {
    await _getToken();
    final response =
        await http.get(Uri.parse('$baseUrl/orders'), headers: _setHeaders());
    return response;
  }

  Future getOrderDetail(id) async {
    await _getToken();
    final response = await http.get(Uri.parse('$baseUrl/orders/$id'),
        headers: _setHeaders());
    return response;
  }

  Future trackOrder(id) async {
    await _getToken();
    final response = await http.post(Uri.parse('$baseUrl/orders/track/$id'),
        headers: _setHeaders());
    return response;
  }

  checkout(data) async {
    await _getToken();
    return await http.post(Uri.parse('$baseUrl/orders'),
        body: data, headers: _setHeaders());
  }

// address APIs
  Future getAddresses() async {
    await _getToken();
    final response =
        await http.get(Uri.parse('$baseUrl/addresses'), headers: _setHeaders());
    return response;
  }

  Future showAddress(id) async {
    await _getToken();
    final response = await http.get(Uri.parse('$baseUrl/address/$id'),
        headers: _setHeaders());
    return response;
  }

  createAddress(data) async {
    await _getToken();
    return await http.post(Uri.parse('$baseUrl/address/create'),
        body: data, headers: _setHeaders());
  }

  updateAddress(data, id) async {
    await _getToken();
    return await http.post(Uri.parse('$baseUrl/address/update/$id'),
        body: data, headers: _setHeaders());
  }

  deleteAddress(id) async {
    await _getToken();
    return await http.delete(Uri.parse('$baseUrl/address/delete/$id'),
        headers: _setHeaders());
  }

  setDefaultAddress(id) async {
    await _getToken();
    return await http.patch(Uri.parse('$baseUrl/addresses/$id/set-default'),
        headers: _setHeaders());
  }

  // comments APIs
  Future getComments(id) async {
    await _getToken();
    final response = await http.get(Uri.parse('$baseUrl/products/$id/comments'),
        headers: _setHeaders());
    return response;
  }

  createComment(data, id) async {
    await _getToken();
    return await http.post(Uri.parse('$baseUrl/products/$id/comments'),
        body: data, headers: _setHeaders());
  }

  deleteComment(id) async {
    await _getToken();
    return await http.delete(Uri.parse('$baseUrl/comments/$id'),
        headers: _setHeaders());
  }

  // Feedback APIs
  Future getFeedback() async {
    await _getToken();
    final response =
        await http.get(Uri.parse('$baseUrl/feedback'), headers: _setHeaders());
    return response;
  }

  createFeedback(data, id) async {
    await _getToken();
    return await http.post(Uri.parse('$baseUrl/oders/$id/feedback'),
        body: data, headers: _setHeaders());
  }

  deleteFeedback(id) async {
    await _getToken();
    return await http.delete(Uri.parse('$baseUrl/feedback/$id'),
        headers: _setHeaders());
  }

  // Notification APIs
  _setLoginHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
}
