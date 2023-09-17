

import 'package:terrortracker/db/user.dart';

import 'DbHelper.dart';

abstract class LoginCallBack {
  void onLoginSuccess(user usr);
  void onLoginError(String error);
}
abstract class RegCallBack {
  void onRegSuccess(int usr);
  void onRegError(String error);
}
class LoginResponse {
  final LoginCallBack _callBack;
  LoginRequest loginRequest = LoginRequest();
  LoginResponse(this._callBack);

  doLogin(String username, String password) {
    loginRequest
        .getLogin(username, password)
        .then((usr) => _callBack.onLoginSuccess(usr!))
        .catchError((onError) => _callBack.onLoginError("User not Found Try Checking \n your Email or Password"));
  }
}
class LoginRequest {
  final dbHelper = DatabaseHelper.instance;

  Future<user?> getLogin(String username, String password) {

    return dbHelper.getLogin(username,password);
  }
}
 class RegisterResponse {
   final RegCallBack calBack;
   RegisterRequest RegRequest = RegisterRequest();

   RegisterResponse(this.calBack);



  doRegister(String username, String password,String email) {
    RegRequest.saveUser(username, password,email)
        .then((usr) => calBack.onRegSuccess(usr))
        .catchError((onError) => calBack.onRegError("Error : $onError"));
  }
}
class RegisterRequest {
  final dbHelper = DatabaseHelper.instance;

  Future<int> saveUser(String username, String password,String email) {
    print(username);
    print(password);
    print(email);

   //  Map<String, dynamic> row = {
   //
   //    username: username,
   //   password: password,
   //   email: email,
   //
   //  };
   // user dr = user.fromMap(row);
   // print(dr);
    var result = dbHelper.saveUser(username,password,email);
    return result;
  }
}