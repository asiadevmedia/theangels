import 'package:viserpay/data/model/bank-transfer/bank_transfer_response_modal.dart';
import 'package:viserpay/data/model/global/meassage_model.dart';

class BankTransferSuccessModel {
  String? remark;
  String? status;
  Message? message;
  Data? data;

  BankTransferSuccessModel({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory BankTransferSuccessModel.fromJson(Map<String, dynamic> json) => BankTransferSuccessModel(
        remark: json["remark"],
        status: json["status"].toString(),
        message: json["message"] == null ? null : Message.fromJson(json["message"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "remark": remark,
        "status": status,
        "message": message?.toJson(),
      };
}

class Data {
  String? actionID;
  BankTransfer? bankTransfer;
  Transaction? transaction;
  Bank? bank;
  Data({
    this.actionID,
    this.bankTransfer,
    this.transaction,
    this.bank,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        actionID: json["action_id"] == null ? 'null' : json["action_id"].toString(),
        bankTransfer: json["bank_transfer"] == null ? null : BankTransfer.fromJson(json["bank_transfer"]),
        transaction: json["transaction"] == null ? null : Transaction.fromJson(json["transaction"]),
        bank: json["bank"] == null ? null : Bank.fromJson(json["bank"]),
      );
}

class BankTransfer {
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

  BankTransfer({
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

  factory BankTransfer.fromJson(Map<String, dynamic> json) => BankTransfer(
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

class Transaction {
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
