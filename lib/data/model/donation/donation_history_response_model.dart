
import 'dart:convert';

import 'package:viserpay/data/model/global/meassage_model.dart';

DonationHistoryResponseModel donationHistoryResponseModelFromJson(String str) => DonationHistoryResponseModel.fromJson(json.decode(str));

String donationHistoryResponseModelToJson(DonationHistoryResponseModel data) => json.encode(data.toJson());

class DonationHistoryResponseModel {
  String? remark;
  String? status;
  Message? message;
  Data? data;

  DonationHistoryResponseModel({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory DonationHistoryResponseModel.fromJson(Map<String, dynamic> json) => DonationHistoryResponseModel(
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
  List<DonationHistory>? data;
  dynamic nextPageUrl;

  History({
    this.data,
    this.nextPageUrl,
  });

  factory History.fromJson(Map<String, dynamic> json) => History(

        data: json["data"] == null ? [] : List<DonationHistory>.from(json["data"]!.map((x) => DonationHistory.fromJson(x))),
        nextPageUrl: json["next_page_url"],
      );

  Map<String, dynamic> toJson() => {

        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
      };
}

class DonationHistory {
  int? id;
  String? setupDonationId;
  String? userId;
  String? userType;
  String? receiverId;
  dynamic receiverType;
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
  DonationFor? donationFor;

  DonationHistory({
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
    this.donationFor,
  });

  factory DonationHistory.fromJson(Map<String, dynamic> json) => DonationHistory(
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
        createdAt: json["created_at"] ,
        updatedAt: json["updated_at"] ,
        donationFor: json["donation_for"] == null ? null : DonationFor.fromJson(json["donation_for"]),
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
        "donation_for": donationFor?.toJson(),
      };
}

class DonationFor {
  int? id;
  String? name;
  String? address;
  String? image;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? getImage;

  DonationFor({
    this.id,
    this.name,
    this.address,
    this.image,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.getImage,
  });

  factory DonationFor.fromJson(Map<String, dynamic> json) => DonationFor(
        id: json["id"],
        name: json["name"],
        address: json["address"],
        image: json["image"],
        status: json["status"].toString(),
        createdAt: json["created_at"] ,
        updatedAt: json["updated_at"] ,
        getImage: json["get_image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
        "image": image,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "get_image": getImage,
      };
}
