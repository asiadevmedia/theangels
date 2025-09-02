import 'dart:convert';
import 'package:viserpay/core/helper/string_format_helper.dart';
import 'package:viserpay/data/model/bank-transfer/bank_transfer_history_model.dart';
import 'package:viserpay/data/model/global/meassage_model.dart';

RechargeResponseModel sendMoneyResponseModelFromJson(String str) => RechargeResponseModel.fromJson(json.decode(str));

String sendMoneyResponseModelToJson(RechargeResponseModel data) => json.encode(data.toJson());

class RechargeResponseModel {
  String? remark;
  String? status;
  Message? message;
  Data? data;

  RechargeResponseModel({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory RechargeResponseModel.fromJson(Map<String, dynamic> json) => RechargeResponseModel(
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
  List<String>? otpType;
  String? currentBalance;
  RechargeCharge? rechargeCharge;
  List<MobileOperator>? mobileOperators;
  List<LatestMobileRecharge>? latestRechargeHistory;

  Data({
    this.otpType,
    this.currentBalance,
    this.rechargeCharge,
    this.mobileOperators,
    this.latestRechargeHistory,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        otpType: json["otp_type"] == null ? [] : List<String>.from(json["otp_type"]!.map((x) => x)),
        currentBalance: json["current_balance"] == null ? "" :json["current_balance"].toString().removeComma().removeComma(),
        rechargeCharge: json["mobile_recharge_charge"] == null ? null : RechargeCharge.fromJson(json["mobile_recharge_charge"]),
        mobileOperators: json["mobile_operators"] == null ? [] : List<MobileOperator>.from(json["mobile_operators"]!.map((x) => MobileOperator.fromJson(x))),
        latestRechargeHistory: json["latest_mobile_recharge_history"] == null ? [] : List<LatestMobileRecharge>.from(json["latest_mobile_recharge_history"]!.map((x) => LatestMobileRecharge.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "otp_type": otpType == null ? [] : List<dynamic>.from(otpType!.map((x) => x)),
        "current_balance": currentBalance,
        "mobile_recharge_charge": rechargeCharge?.toJson(),
        "latest_mobile_recharge_history": latestRechargeHistory == null ? [] : List<dynamic>.from(latestRechargeHistory!.map((x) => x.toJson())),
      };
}

class RechargeCharge {
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
  String? createdAt;
  String? updatedAt;

  RechargeCharge({
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
    this.createdAt,
    this.updatedAt,
  });

  factory RechargeCharge.fromJson(Map<String, dynamic> json) => RechargeCharge(
        id: json["id"],
        slug: json["slug"],
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
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
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

class LatestMobileRecharge {
  int? id;
  String? userId;
  String? mobileOperatorId;
  String? mobile;
  String? amount;
  String? trx;
  String? adminFeedback;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? statusBadge;
  MobileOperator? mobileOperator;
  GetTrx? transaction;

  LatestMobileRecharge({
    this.id,
    this.userId,
    this.mobileOperatorId,
    this.mobile,
    this.amount,
    this.trx,
    this.adminFeedback,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.statusBadge,
    this.mobileOperator,
    this.transaction,
  });

  factory LatestMobileRecharge.fromJson(Map<String, dynamic> json) => LatestMobileRecharge(
        id: json["id"],
        userId: json["user_id"].toString(),
        mobileOperatorId: json["mobile_operator_id"] != null ? json["mobile_operator_id"].toString() : '',
        mobile: json["mobile"].toString(),
        amount: json["amount"] != null ? json["amount"].toString() : '',
        trx: json["trx"],
        adminFeedback: json["admin_feedback"].toString(),
        status: json["status"].toString(),
        createdAt: json["created_at"]?.toString(),
        updatedAt: json["updated_at"]?.toString(),
        statusBadge: json["status_badge"].toString(),
        mobileOperator: json["mobile_operator"] == null ? null : MobileOperator.fromJson(json["mobile_operator"]),
        transaction: json["get_trx"] == null ? null : GetTrx.fromJson(json["get_trx"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "mobile_operator_id": mobileOperatorId,
        "mobile": mobile,
        "amount": amount,
        "trx": trx,
        "admin_feedback": adminFeedback,
        "status": status,
        "created_at": createdAt?.toString(),
        "updated_at": updatedAt?.toString(),
        "status_badge": statusBadge,
        "mobile_operator": mobileOperator?.toJson(),
        "get_trx": transaction?.toJson(),
      };
}

class MobileOperator {
  int id;
  String? name;
  String? image;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? getImage;

  MobileOperator({
    required this.id,
    this.name,
    this.image,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.getImage,
  });

  factory MobileOperator.fromJson(Map<String, dynamic> json) => MobileOperator(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        status: json["status"].toString(),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        getImage: json["get_image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "get_image": getImage,
      };
}
