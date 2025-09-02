
import 'dart:convert';
import 'package:viserpay/data/model/global/marchent_exist/marchent_exist_modal.dart';
import 'package:viserpay/data/model/global/meassage_model.dart';

MakePaymentSubmitResponseModal sendMoneysubmitResponseModalFromJson(String str) => MakePaymentSubmitResponseModal.fromJson(json.decode(str));

String sendMoneysubmitResponseModalToJson(MakePaymentSubmitResponseModal data) => json.encode(data.toJson());

class MakePaymentSubmitResponseModal {
  String? remark;
  String? status;
  Message? message;
  Data? data;

  MakePaymentSubmitResponseModal({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory MakePaymentSubmitResponseModal.fromJson(Map<String, dynamic> json) => MakePaymentSubmitResponseModal(
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
  MakePayment? makePayment;
  String? actionID;

  Data({
    this.actionID,
    this.makePayment,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        actionID: json["action_id"] == null ? 'null' : json["action_id"].toString(),
        makePayment: json["make_payment"] == null ? null : MakePayment.fromJson(json["make_payment"]),
      );

  Map<String, dynamic> toJson() => {
        "action_id": actionID,
        "send_money": makePayment?.toJson(),
      };
}

class MakePayment {
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
  Merchant? receiverUser;

  MakePayment({
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

  factory MakePayment.fromJson(Map<String, dynamic> json) => MakePayment(
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
        updatedAt: json["updated_at"].toString(),
        createdAt: json["created_at"].toString(),
        id: json["id"],
        receiverUser: json["receiver_merchant"] == null ? null : Merchant.fromJson(json["receiver_merchant"]),
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
