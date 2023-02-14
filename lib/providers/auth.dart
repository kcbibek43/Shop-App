import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shop_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  late String _token;
  late DateTime _expiryDate = DateTime.now() ;
  late String _userId;
  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final Uri url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCimlISrK4vK4ifjpbdirDmu9uKcc5k7Is');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      final resposeData = json.decode(response.body);
      if (resposeData['error'] != null) {
        throw HttpException(resposeData['error']['message']);
      }
      _token = resposeData['idToken'];
      _userId = resposeData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(seconds: int.parse(resposeData['expiresIn'])),
      );
      notifyListeners();
    } catch (error) {
      rethrow;
    }
    // print (json.decode(response.body));
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> logIn(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}
