
import 'dart:convert';

import 'package:viserpay/data/model/auth/sign_up_model/registration_response_model.dart';

TransactionLimitResponseModel transactionLimitResponseModelFromJson(String str) => TransactionLimitResponseModel.fromJson(json.decode(str));

String transactionLimitResponseModelToJson(TransactionLimitResponseModel data) => json.encode(data.toJson());

class TransactionLimitResponseModel {
  String? remark;
  String? status;
  Message? message;
  Data? data;

  TransactionLimitResponseModel({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory TransactionLimitResponseModel.fromJson(Map<String, dynamic> json) => TransactionLimitResponseModel(
        remark: json["remark"],
        status: json["status"].toString(),
        message: json["message"] == null ? null : Message.fromJson(json["message"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "remark": remark,
        "status": status,
        "message": message?.toJson(),
        "data": data?.toJson(),
      };
}

class Data {
  List<TransactionChargeModel>? transactionCharge;

  Data({
    this.transactionCharge,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        transactionCharge: json["transaction_charges"] == null ? [] : List<TransactionChargeModel>.from(json["transaction_charges"]!.map((x) => TransactionChargeModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "transaction_charges": transactionCharge == null ? [] : List<dynamic>.from(transactionCharge!.map((x) => x.toJson())),
      };
}

class TransactionChargeModel {
  int? id;
  String? slug;
  String? fixedCharge;
  String? percentCharge;
  String? minLimit;
  String? maxLimit;
  String? agentCommissionFixed;
  String? agentCommissionPercent;
  String? merchantFixedCharge;
  String? merchantPercentCharge;
  String? monthlyLimit;
  String? dailyLimit;
  String? dailyRequestAcceptLimit;
  String? cap;
  String? dailyUsed;
  String? monthlyUsed;
  String? createdAt;
  String? updatedAt;

  TransactionChargeModel({
    this.id,
    this.slug,
    this.fixedCharge,
    this.percentCharge,
    this.minLimit,
    this.maxLimit,
    this.agentCommissionFixed,
    this.agentCommissionPercent,
    this.merchantFixedCharge,
    this.merchantPercentCharge,
    this.monthlyLimit,
    this.dailyLimit,
    this.dailyRequestAcceptLimit,
    this.cap,
    this.dailyUsed,
    this.monthlyUsed,
    this.createdAt,
    this.updatedAt,
  });

  factory TransactionChargeModel.fromJson(Map<String, dynamic> json) => TransactionChargeModel(
        id: json["id"],
        slug: json["slug"].toString(),
        fixedCharge: json["fixed_charge"].toString(),
        percentCharge: json["percent_charge"].toString(),
        minLimit: json["min_limit"].toString(),
        maxLimit: json["max_limit"].toString(),
        agentCommissionFixed: json["agent_commission_fixed"].toString(),
        agentCommissionPercent: json["agent_commission_percent"].toString(),
        merchantFixedCharge: json["merchant_fixed_charge"].toString(),
        merchantPercentCharge: json["merchant_percent_charge"].toString(),
        monthlyLimit: json["monthly_limit"].toString(),
        dailyLimit: json["daily_limit"].toString(),
        dailyRequestAcceptLimit: json["daily_request_accept_limit"].toString(),
        cap: json["cap"].toString(),
        dailyUsed: json["daily_used"] != null ? json["daily_used"].toString() : "",
        monthlyUsed: json["monthly_used"] != null ? json["monthly_used"].toString() : "",
        createdAt: json["created_at"] ,
        updatedAt: json["updated_at"] ,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "slug": slug,
        "fixed_charge": fixedCharge,
        "percent_charge": percentCharge,
        "min_limit": minLimit,
        "max_limit": maxLimit,
        "agent_commission_fixed": agentCommissionFixed,
        "agent_commission_percent": agentCommissionPercent,
        "merchant_fixed_charge": merchantFixedCharge,
        "merchant_percent_charge": merchantPercentCharge,
        "monthly_limit": monthlyLimit,
        "daily_limit": dailyLimit,
        "daily_request_accept_limit": dailyRequestAcceptLimit,
        "cap": cap,
        "created_at": createdAt?.toString(),
        "updated_at": updatedAt?.toString(),
      };
}
