import 'dart:convert';

SuccessModel successModelFromJson(String str) => SuccessModel.fromJson(json.decode(str));

String successModelToJson(SuccessModel data) => json.encode(data.toJson());

class SuccessModel {
    SuccessModel({
        this.res,
        this.msg,
    });

    int? res;
    String? msg;

    factory SuccessModel.fromJson(Map<String, dynamic> json) => SuccessModel(
        res: json["res"],
        msg: json["msg"],
    );

    Map<String, dynamic> toJson() => {
        "res": res,
        "msg": msg,
    };
}
