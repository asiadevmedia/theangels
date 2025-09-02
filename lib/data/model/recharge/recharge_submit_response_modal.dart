
import 'dart:convert';

import 'package:viserpay/data/model/global/meassage_model.dart';
import 'package:viserpay/data/model/recharge/recharge_data_response_modal.dart';

RechargeResponseModel sendMoneyResponseModelFromJson(String str) => RechargeResponseModel.fromJson(json.decode(str));

String sendMoneyResponseModelToJson(RechargeResponseModel data) => json.encode(data.toJson());

class RechargeSubmitResponseModel {
  String? remark;
  String? status;
  Message? message;
  Data? data;

  RechargeSubmitResponseModel({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory RechargeSubmitResponseModel.fromJson(Map<String, dynamic> json) => RechargeSubmitResponseModel(
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
  MobileRecharge? mobileRecharge;
  Transaction? transaction;
  String? actionID;
  Data({
    this.mobileRecharge,
    this.transaction,
    this.actionID,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        mobileRecharge: json["mobile_recharge"] == null ? null : MobileRecharge.fromJson(json['mobile_recharge']),
        transaction: json["transaction"] == null ? null : Transaction.fromJson(json["transaction"]),
        actionID: json["action_id"] == null ? 'null' : json["action_id"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "mobile_recharge": mobileRecharge?.toJson(),
        "transaction": transaction?.toJson(),
      };
}

class MobileRecharge {
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

  MobileRecharge({
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
  });

  factory MobileRecharge.fromJson(Map<String, dynamic> json) => MobileRecharge(
        id: json["id"],
        userId: json["user_id"] != null ? json["user_id"].toString() : '',
        mobileOperatorId: json["mobile_operator_id"] != null ? json["mobile_operator_id"].toString() : '',
        mobile: json["mobile"].toString(),
        amount: json["amount"].toString(),
        trx: json["trx"],
        adminFeedback: json["admin_feedback"].toString(),
        status: json["status"].toString(),
        createdAt: json["created_at"] ,
        updatedAt: json["updated_at"] ,
        statusBadge: json["status_badge"].toString(),
        mobileOperator: json["mobile_operator"] == null ? null : MobileOperator.fromJson(json["mobile_operator"]),
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
      };
}

class Transaction {
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
  int? id;

  Transaction({
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
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        userId: json["user_id"] == null ? "" : json["user_id"].toString(),
        userType: json["user_type"].toString(),
        beforeCharge: json["before_charge"] == null ? "" : json["before_charge"].toString(),
        amount: json["amount"] == null ? "" : json["amount"]?.toString(),
        postBalance: json["post_balance"] == null ? "" : json["post_balance"]?.toString(),
        charge: json["charge"] == null ? "" : json["charge"].toString(),
        chargeType: json["charge_type"].toString(),
        trxType: json["trx_type"].toString(),
        remark: json["remark"].toString(),
        details: json["details"].toString(),
        receiverId: json["receiver_id"] == null ? "" : json["receiver_id"].toString(),
        receiverType: json["receiver_type"].toString(),
        trx: json["trx"].toString(),
        updatedAt: json["updated_at"],
        createdAt: json["created_at"],
        id: json["id"],
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
      };
}
