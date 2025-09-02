// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:viserpay/data/model/global/meassage_model.dart';

SendMoneyResponseModel sendMoneyResponseModelFromJson(String str) => SendMoneyResponseModel.fromJson(json.decode(str));

String sendMoneyResponseModelToJson(SendMoneyResponseModel data) => json.encode(data.toJson());

class SendMoneyResponseModel {
  String? remark;
  String? status;
  Message? message;
  Data? data;

  SendMoneyResponseModel({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory SendMoneyResponseModel.fromJson(Map<String, dynamic> json) => SendMoneyResponseModel(
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
  SendMoneyCharge? sendMoneyCharge;
  List<LatestSendMoneyHistory>? latestSendMoneyHistory;

  Data({
    this.otpType,
    this.currentBalance,
    this.sendMoneyCharge,
    this.latestSendMoneyHistory,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        otpType: json["otp_type"] == null ? [] : List<String>.from(json["otp_type"]!.map((x) => x)),
        currentBalance: json["current_balance"] ?? "",
        sendMoneyCharge: json["send_money_charge"] == null ? null : SendMoneyCharge.fromJson(json["send_money_charge"]),
        latestSendMoneyHistory: json["latest_send_money_history"] == null ? [] : List<LatestSendMoneyHistory>.from(json["latest_send_money_history"]!.map((x) => LatestSendMoneyHistory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "otp_type": otpType == null ? [] : List<dynamic>.from(otpType!.map((x) => x)),
        "current_balance": currentBalance,
        "send_money_charge": sendMoneyCharge?.toJson(),
        "latest_send_money_history": latestSendMoneyHistory == null ? [] : List<dynamic>.from(latestSendMoneyHistory!.map((x) => x.toJson())),
      };
}

class LatestSendMoneyHistory {
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
  RelatedTransaction? relatedTransaction;

  LatestSendMoneyHistory({
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
    this.relatedTransaction,
  });

  factory LatestSendMoneyHistory.fromJson(Map<String, dynamic> json) {
    print("transascxtion $json");
    print("related ${json["related_transaction"]}");
    return LatestSendMoneyHistory(
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
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
      receiverUser: json["receiver_user"] == null ? null : ReceiverUser.fromJson(json["receiver_user"]),
      relatedTransaction: json["related_transaction"] == null ? null : RelatedTransaction.fromJson(json["related_transaction"]),
    );
  }

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
        "receiver_user": receiverUser?.toJson(),
      };
}

class ReceiverUser {
  int? id;
  String? firstname;
  String? lastname;
  String? username;
  String? email;
  String? countryCode;
  String? mobile;
  String? refBy;
  AddressClass? address;
  String? image;
  String? status;
  String? kv;
  String? ev;
  String? sv;
  String? profileComplete;
  String? verCodeSendAt;
  String? ts;
  String? tv;
  String? tsc;
  String? banReason;
  String? createdAt;
  String? updatedAt;
  String? getImage;

  ReceiverUser({
    this.id,
    this.firstname,
    this.lastname,
    this.username,
    this.email,
    this.countryCode,
    this.mobile,
    this.refBy,
    this.address,
    this.image,
    this.status,
    this.kv,
    this.ev,
    this.sv,
    this.profileComplete,
    this.verCodeSendAt,
    this.ts,
    this.tv,
    this.tsc,
    this.banReason,
    this.createdAt,
    this.updatedAt,
    this.getImage,
  });

  factory ReceiverUser.fromJson(Map<String, dynamic> json) {
    return ReceiverUser(
      id: json["id"],
      firstname: json["firstname"],
      lastname: json["lastname"],
      username: json["username"] ?? '',
      email: json["email"],
      countryCode: json["country_code"].toString(),
      mobile: json["mobile"].toString(),
      refBy: json["ref_by"].toString(),
      address: json["address"] == null ? null : AddressClass.fromJson(json["address"]),
      image: json["image"].toString(),
      status: json["status"].toString(),
      kv: json["kv"].toString(),
      ev: json["ev"].toString(),
      sv: json["sv"].toString(),
      profileComplete: json["profile_complete"].toString(),
      verCodeSendAt: json["ver_code_send_at"].toString(),
      ts: json["ts"].toString(),
      tv: json["tv"].toString(),
      tsc: json["tsc"] == null ? '' : json["tsc"].toString(),
      banReason: json["ban_reason"].toString(),
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
      getImage: json["get_image"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstname": firstname,
        "lastname": lastname,
        "username": username,
        "email": email,
        "country_code": countryCode,
        "mobile": mobile,
        "ref_by": refBy,
        "address": address?.toJson(),
        "image": image,
        "status": status,
        "kv": kv,
        "ev": ev,
        "sv": sv,
        "profile_complete": profileComplete,
        "ver_code_send_at": verCodeSendAt?.toString(),
        "ts": ts,
        "tv": tv,
        "tsc": tsc,
        "ban_reason": banReason,
        "created_at": createdAt?.toString(),
        "updated_at": updatedAt?.toString(),
        "get_image": getImage,
      };
}

class AddressClass {
  String? address;
  String? state;
  String? zip;
  String? country;
  String? city;

  AddressClass({
    this.address,
    this.state,
    this.zip,
    this.country,
    this.city,
  });

  factory AddressClass.fromJson(Map<String, dynamic> json) => AddressClass(
        address: json["address"],
        state: json["state"],
        zip: json["zip"],
        country: json["country"],
        city: json["city"],
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "state": state,
        "zip": zip,
        "country": country,
        "city": city,
      };
}

class SendMoneyCharge {
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

  SendMoneyCharge({
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

  factory SendMoneyCharge.fromJson(Map<String, dynamic> json) => SendMoneyCharge(
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

class RelatedTransaction {
  int? id;
  int? setupDonationId;
  int? userId;
  String? userType;
  int? receiverId;
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
  dynamic reference;
  int? hideIdentity;
  String? createdAt;
  String? updatedAt;
  ReceiverUser? user;

  RelatedTransaction({
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
    this.user,
  });

  factory RelatedTransaction.fromJson(Map<String, dynamic> json) {
    return RelatedTransaction(
      id: json["id"],
      setupDonationId: json["setup_donation_id"],
      userId: json["user_id"],
      userType: json["user_type"],
      receiverId: json["receiver_id"],
      receiverType: json["receiver_type"],
      beforeCharge: json["before_charge"],
      amount: json["amount"],
      charge: json["charge"],
      postBalance: json["post_balance"],
      trxType: json["trx_type"],
      chargeType: json["charge_type"],
      trx: json["trx"],
      details: json["details"],
      remark: json["remark"],
      reference: json["reference"],
      hideIdentity: json["hide_identity"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
      user: json["user"] == null ? null : ReceiverUser.fromJson(json["user"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "setup_donation_id": setupDonationId,
        "user_id": userId,
        "user_type": userType,
        "receiver_id": receiverId,
        "receiver_type": receiverType,
        "before_charge": beforeCharge,
        "amount": amount,
        "charge": charge,
        "post_balance": postBalance,
        "trx_type": trxType,
        "charge_type": chargeType,
        "trx": trx,
        "details": details,
        "remark": remark,
        "reference": reference,
        "hide_identity": hideIdentity,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "user": user?.toJson(),
      };
}
