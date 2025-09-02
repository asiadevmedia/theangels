// To parse this JSON data, do
//
//     final sendMoneyHistoryResponseModel = sendMoneyHistoryResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:viserpay/data/model/global/meassage_model.dart';
import 'package:viserpay/data/model/recharge/recharge_data_response_modal.dart';
import 'package:viserpay/data/model/transctions/transaction_response_model.dart';

RechargeHistoryResponseModel sendMoneyHistoryResponseModelFromJson(String str) => RechargeHistoryResponseModel.fromJson(json.decode(str));

String sendMoneyHistoryResponseModelToJson(RechargeHistoryResponseModel data) => json.encode(data.toJson());

class RechargeHistoryResponseModel {
  String? remark;
  String? status;
  Message? message;
  Data? data;

  RechargeHistoryResponseModel({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory RechargeHistoryResponseModel.fromJson(Map<String, dynamic> json) => RechargeHistoryResponseModel(
        remark: json["remark"],
        status: json["status"],
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
  History? history;

  Data({
    this.history,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        history: json["history"] == null ? null : History.fromJson(json["history"]),
      );

  Map<String, dynamic> toJson() => {
        "history": history?.toJson(),
      };
}

class History {
  int? currentPage;
  List<LatestMobileRecharge>? data;
  String? nextPageUrl;

  History({
    this.currentPage,
    this.data,
    this.nextPageUrl,
  });

  factory History.fromJson(Map<String, dynamic> json) => History(
        currentPage: json["current_page"],
        data: json["data"] == null ? [] : List<LatestMobileRecharge>.from(json["data"]!.map((x) => LatestMobileRecharge.fromJson(x))),
        nextPageUrl: json["next_page_url"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
      };
}

class SendMoneyHistoryData {
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
  User? receiverUser;

  SendMoneyHistoryData({
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

  factory SendMoneyHistoryData.fromJson(Map<String, dynamic> json) => SendMoneyHistoryData(
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
        reference: json["reference"].toString(),
        hideIdentity: json["hide_identity"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        receiverUser: json["receiver_user"] == null ? null : User.fromJson(json["receiver_user"]),
      );

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
        "receiver_user": receiverUser?.toJson(),
      };
}
