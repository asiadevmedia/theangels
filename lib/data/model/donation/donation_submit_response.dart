
import 'dart:convert';

import 'package:viserpay/data/model/global/meassage_model.dart';

DonationSubmitResponseModal sendMoneysubmitResponseModalFromJson(String str) => DonationSubmitResponseModal.fromJson(json.decode(str));

String sendMoneysubmitResponseModalToJson(DonationSubmitResponseModal data) => json.encode(data.toJson());

class DonationSubmitResponseModal {
  String? remark;
  String? status;
  Message? message;
  Data? data;

  DonationSubmitResponseModal({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory DonationSubmitResponseModal.fromJson(Map<String, dynamic> json) => DonationSubmitResponseModal(
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
  Donation? donation;
  String? actionID;

  Data({
    this.actionID,
    this.donation,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        actionID: json["action_id"] == null ? 'null' : json["action_id"].toString(),
        donation: json["donation"] == null ? null : Donation.fromJson(json["donation"]),
      );

  Map<String, dynamic> toJson() => {
        "action_id": actionID,
        "donation": donation?.toJson(),
      };
}

class Donation {
  int? id;
  String? donationId;
  String? userId;
  String? userType;
  String? beforeCharge;
  String? amount;
  String? postBalance;
  String? charge;
  String? chargeType;
  String? trxType;
  String? remark;
  String? details;
  String? receiverId;
  String? receiverType;
  String? trx;
  String? updatedAt;
  String? createdAt;
  DonationOrgination? receiverOrganization;

  Donation({
    this.donationId,
    this.userId,
    this.userType,
    this.beforeCharge,
    this.amount,
    this.postBalance,
    this.charge,
    this.chargeType,
    this.trxType,
    this.remark,
    this.details,
    this.receiverId,
    this.receiverType,
    this.trx,
    this.updatedAt,
    this.createdAt,
    this.id,
    this.receiverOrganization,
  });

  factory Donation.fromJson(Map<String, dynamic> json) => Donation(
        donationId: json["setup_donation_id"] == null ? '' : json["setup_donation_id"].toString(),
        userId: json["user_id"] == null ? '' : json["user_id"].toString(),
        userType: json["user_type"].toString(),
        beforeCharge: json["before_charge"].toString(),
        amount: json["amount"] == null ? '' : json["amount"].toString(),
        postBalance: json["post_balance"] == null ? '' : json["post_balance"].toString(),
        charge: json["charge"] == null ? '' : json["charge"].toString(),
        chargeType: json["charge_type"].toString(),
        trxType: json["trx_type"].toString(),
        remark: json["remark"].toString(),
        details: json["details"].toString(),
        receiverId: json["receiver_id"] == null ? '' : json["receiver_id"].toString(),
        receiverType: json["receiver_type"].toString(),
        trx: json["trx"].toString(),
        updatedAt: json["updated_at"],
        createdAt: json["created_at"] ,
        id: json["id"],
        receiverOrganization: json["donation_for"] == null ? null : DonationOrgination.fromJson(json["donation_for"]),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "user_type": userType,
        "before_charge": beforeCharge,
        "amount": amount,
        "post_balance": postBalance,
        "charge": charge,
        "charge_type": chargeType,
        "trx_type": trxType,
        "remark": remark,
        "details": details,
        "receiver_id": receiverId,
        "receiver_type": receiverType,
        "trx": trx,
        "updated_at": updatedAt?.toString(),
        "created_at": createdAt?.toString(),
        "id": id,
        "donation_for": receiverOrganization?.toJson(),
      };
}

class DonationOrgination {
  int? id;
  String? name;
  String? address;
  String? image;
  String? getImage;
  String? status;
  String? createdAt;
  String? updatedAt;

  DonationOrgination({
    this.id,
    this.name,
    this.address,
    this.image,
    this.getImage,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory DonationOrgination.fromJson(Map<String, dynamic> json) => DonationOrgination(
        id: json["id"],
        name: json["name"]??'',
        address: json["address"].toString(),
        image: json["image"].toString(),
        getImage: json["get_image"].toString(),
        status: json["status"].toString(),
        createdAt: json["created_at"] ,
        updatedAt: json["updated_at"] ,
      );

  Map<String, dynamic> toJson() => {};
}
