
import 'dart:convert';

import 'package:viserpay/data/model/global/usercheck/user_check_response_modal.dart';
import 'package:viserpay/data/model/global/meassage_model.dart';

CashoutSubmitResponseModal sendMoneysubmitResponseModalFromJson(String str) => CashoutSubmitResponseModal.fromJson(json.decode(str));

String sendMoneysubmitResponseModalToJson(CashoutSubmitResponseModal data) => json.encode(data.toJson());

class CashoutSubmitResponseModal {
  String? remark;
  String? status;
  Message? message;
  Data? data;

  CashoutSubmitResponseModal({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory CashoutSubmitResponseModal.fromJson(Map<String, dynamic> json) => CashoutSubmitResponseModal(
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
  Cashout? cashout;
  String? actionID;

  Data({
    this.actionID,
    this.cashout,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        actionID: json["action_id"] == null ? 'null' : json["action_id"].toString(),
        cashout: json["cash_out"] == null ? null : Cashout.fromJson(json["cash_out"]),
      );

  Map<String, dynamic> toJson() => {
        "action_id": actionID,
        "send_money": cashout?.toJson(),
      };
}

class Cashout {
  int? id;
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
  User? receiverUser;

  Cashout({
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
    this.receiverUser,
  });

  factory Cashout.fromJson(Map<String, dynamic> json) => Cashout(
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
        updatedAt: json["updated_at"] ,
        createdAt: json["created_at"] ,
        id: json["id"],
        receiverUser: json["receiver_agent"] == null ? null : User.fromJson(json["receiver_agent"]),
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
        "receiver_user": receiverUser?.toJson(),
      };
}
