import 'dart:convert';

import 'package:viserpay/core/helper/string_format_helper.dart';
import 'package:viserpay/data/model/global/meassage_model.dart';
import 'package:viserpay/data/model/global/receive_agent_model/receive_agent_model.dart';

MakepaymentResponseModal makepaymentResponseModalFromJson(String str) => MakepaymentResponseModal.fromJson(json.decode(str));

String makepaymentResponseModalToJson(MakepaymentResponseModal data) => json.encode(data.toJson());

class MakepaymentResponseModal {
  String? remark;
  String? status;
  Message? message;
  Data? data;

  MakepaymentResponseModal({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory MakepaymentResponseModal.fromJson(Map<String, dynamic> json) => MakepaymentResponseModal(
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
  MakePaymentCharge? makePaymentCharge;
  List<LatestMakePaymentHistory>? latestMakePaymentHistory;

  Data({
    this.otpType,
    this.currentBalance,
    this.makePaymentCharge,
    this.latestMakePaymentHistory,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        otpType: json["otp_type"] == null ? [] : List<String>.from(json["otp_type"]!.map((x) => x)),
        currentBalance:json["current_balance"].toString().removeComma(),
        makePaymentCharge: json["make_payment_charge"] == null ? null : MakePaymentCharge.fromJson(json["make_payment_charge"]),
        latestMakePaymentHistory: json["latest_make_payment_history"] == null ? [] : List<LatestMakePaymentHistory>.from(json["latest_make_payment_history"]!.map((x) => LatestMakePaymentHistory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "otp_type": otpType == null ? [] : List<dynamic>.from(otpType!.map((x) => x)),
        "current_balance": currentBalance,
        "make_payment_charge": makePaymentCharge?.toJson(),
        "latest_make_payment_history": latestMakePaymentHistory == null ? [] : List<dynamic>.from(latestMakePaymentHistory!.map((x) => x.toJson())),
      };
}

class MakePaymentCharge {
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

  MakePaymentCharge({
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

  factory MakePaymentCharge.fromJson(Map<String, dynamic> json) => MakePaymentCharge(
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

class LatestMakePaymentHistory {
  int? id;
  String? setupDonationId;
  String? userId;
  String? userType;
  String? receiverId;
  String? receiverType;
  String? beforeCharge;
  String? amount;
  String? charge;
  String? postBalance;
  String? trxType;
  String? chargeType;
  String? trx;
  String? details;
  String? remark;
  String? reference;
  String? hideIdentity;
  String? createdAt;
  String? updatedAt;
  ReceiverUser? receiverUser;

  LatestMakePaymentHistory({
    this.id,
    this.setupDonationId,
    this.userId,
    this.userType,
    this.receiverId,
    this.receiverType,
    this.beforeCharge,
    this.amount,
    this.charge,
    this.postBalance,
    this.trxType,
    this.chargeType,
    this.trx,
    this.details,
    this.remark,
    this.reference,
    this.hideIdentity,
    this.createdAt,
    this.updatedAt,
    this.receiverUser,
  });

  factory LatestMakePaymentHistory.fromJson(Map<String, dynamic> json) => LatestMakePaymentHistory(
        id: json["id"],
        setupDonationId: json["setup_donation_id"].toString(),
        userId: json["user_id"].toString(),
        userType: json["user_type"].toString(),
        receiverId: json["receiver_id"].toString(),
        receiverType: json["receiver_type"].toString(),
        beforeCharge: json["before_charge"].toString(),
        amount: json["amount"].toString(),
        charge: json["charge"].toString(),
        postBalance: json["post_balance"].toString(),
        trxType: json["trx_type"].toString(),
        chargeType: json["charge_type"].toString(),
        trx: json["trx"].toString(),
        details: json["details"].toString(),
        remark: json["remark"].toString(),
        reference: json["reference"].toString(),
        hideIdentity: json["hide_identity"].toString(),
        createdAt: json["created_at"].toString(),
        updatedAt: json["updated_at"].toString(),
        receiverUser: json["receiver_merchant"] == null ? null : ReceiverUser.fromJson(json["receiver_merchant"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "setup_donation_id": setupDonationId,
        "user_id": userId,
        "user_type": [userType],
        "receiver_id": receiverId,
        "receiver_type": [receiverType],
        "before_charge": beforeCharge,
        "amount": amount,
        "charge": charge,
        "post_balance": postBalance,
        "trx_type": [trxType],
        "charge_type": [chargeType],
        "trx": trx,
        "details": [details],
        "remark": [remark],
        "reference": reference,
        "hide_identity": hideIdentity,
        "created_at": createdAt?.toString(),
        "updated_at": updatedAt?.toString(),
        "receiver_merchant": receiverUser?.toJson(),
      };
}
