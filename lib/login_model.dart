import 'dart:convert';

LoginModel loginFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  LoginModel({
    this.res,
    this.msg,
    this.loginToken,
    this.dbName,
    this.userId,
  });

  int? res;
  String? msg;
  String? loginToken;
  String? dbName;
  String? userId;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        res: json["res"],
        msg: json["msg"],
        loginToken: json["LoginToken"],
        dbName: json["DBName"],
        userId: json["UserID"],
      );

  Map<String, dynamic> toJson() => {
        "res": res,
        "msg": msg,
        "LoginToken": loginToken,
        "DBName": dbName,
        "UserID": userId,
      };
}
