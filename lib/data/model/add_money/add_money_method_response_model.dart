import 'dart:convert';
import 'package:viserpay/data/model/global/meassage_model.dart';

AddMoneyResponseModel addMoneyResponseModelFromJson(String str) => AddMoneyResponseModel.fromJson(json.decode(str));

String addMoneyResponseModelToJson(AddMoneyResponseModel data) => json.encode(data.toJson());

class AddMoneyResponseModel {
  String? remark;
  Message? message;
  Data? data;

  AddMoneyResponseModel({
    this.remark,
    this.message,
    this.data,
  });

  factory AddMoneyResponseModel.fromJson(Map<String, dynamic> json) => AddMoneyResponseModel(
    remark: json["remark"],
    message: json["message"] == null ? null : Message.fromJson(json["message"]),
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "remark": remark,
    "message": message?.toJson(),
    "data": data?.toJson(),
  };
}

class Data {
  List<PaymentMethods>? methods;

  Data({
    this.methods,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    methods: json["methods"] == null ? [] : List<PaymentMethods>.from(json["methods"]!.map((x) => PaymentMethods.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "methods": methods == null ? [] : List<dynamic>.from(methods!.map((x) => x.toJson())),
  };
}

class PaymentMethods {
  int? id;
  String? name;
  String? currency;
  String? symbol;
  String? methodCode;
  String? gatewayAlias;
  String? minAmount;
  String? maxAmount;
  String? percentCharge;
  String? fixedCharge;
  String? rate;
  String? image;
  String? createdAt;
  String? updatedAt;
  MethodMethod? method;

  PaymentMethods({
    this.id,
    this.name,
    this.currency,
    this.symbol,
    this.methodCode,
    this.gatewayAlias,
    this.minAmount,
    this.maxAmount,
    this.percentCharge,
    this.fixedCharge,
    this.rate,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.method,
  });

  factory PaymentMethods.fromJson(Map<String, dynamic> json) => PaymentMethods(
        id: json["id"],
        name: json["name"],
        currency: json["currency"].toString(),
        symbol: json["symbol"].toString(),
        methodCode: json["method_code"].toString(),
        gatewayAlias: json["gateway_alias"].toString(),
        minAmount: json["min_amount"].toString(),
        maxAmount: json["max_amount"].toString(),
        percentCharge: json["percent_charge"].toString(),
        fixedCharge: json["fixed_charge"].toString(),
        rate: json["rate"].toString(),
        image: json["image"].toString(),
        createdAt: json["created_at"] ,
        updatedAt: json["updated_at"] ,
        method: json["method"] == null ? null : MethodMethod.fromJson(json["method"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "currency": currency,
        "symbol": symbol,
        "method_code": methodCode,
        "gateway_alias": gatewayAlias,
        "min_amount": minAmount,
        "max_amount": maxAmount,
        "percent_charge": percentCharge,
        "fixed_charge": fixedCharge,
        "rate": rate,
        "image": image,
        "created_at": createdAt?.toString(),
        "updated_at": updatedAt?.toString(),
        "method": method?.toJson(),
      };
}

class MethodMethod {
  int? id;
  String? formId;
  String? code;
  String? name;
  String? alias;
  String? status;
  // Map<String, dynamic>? supportedCurrencies;
  String? crypto;
  String? description;
  String? createdAt;
  String? updatedAt;

  MethodMethod({
    this.id,
    this.formId,
    this.code,
    this.name,
    this.alias,
    this.status,
    // this.supportedCurrencies,
    this.crypto,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory MethodMethod.fromJson(Map<String, dynamic> json) => MethodMethod(
        id: json["id"],
        formId: json["form_id"].toString(),
        code: json["code"].toString(),
        name: json["name"]??'',
        alias: json["alias"].toString(),
        status: json["status"].toString(),
        // supportedCurrencies: json["supported_currencies"].toString(),
        crypto: json["crypto"].toString(),
        description: json["description"].toString(),
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "form_id": formId,
        "code": code,
        "name": name,
        "alias": alias,
        "status": status,
        // "supported_currencies": supportedCurrencies,
        "crypto": crypto,
        "description": description,
        "created_at": createdAt?.toString(),
        "updated_at": updatedAt?.toString(),
      };
}
