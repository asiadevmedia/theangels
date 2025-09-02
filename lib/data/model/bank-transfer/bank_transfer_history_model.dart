import 'dart:convert';

import 'package:viserpay/data/model/global/meassage_model.dart';

BankTransferHistoryResponseModel bankTransferHistoryResponseModelFromJson(String str) => BankTransferHistoryResponseModel.fromJson(json.decode(str));

String bankTransferHistoryResponseModelToJson(BankTransferHistoryResponseModel data) => json.encode(data.toJson());

class BankTransferHistoryResponseModel {
  String? remark;
  String? status;
  Message? message;
  Data? data;

  BankTransferHistoryResponseModel({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory BankTransferHistoryResponseModel.fromJson(Map<String, dynamic> json) => BankTransferHistoryResponseModel(
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
  String? filePath;
  MainData? history;

  Data({
    this.filePath,
    this.history,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        filePath: json["file_path"],
        history: json["history"] == null ? null : MainData.fromJson(json["history"]),
      );

  Map<String, dynamic> toJson() => {
        "file_path": filePath,
        "history": history?.toJson(),
      };
}

class MainData {
  int? currentPage;
  List<BankHistory>? data;
  dynamic nextPageUrl;
  String? path;

  MainData({
    this.currentPage,
    this.data,
    this.nextPageUrl,
    this.path,
  });

  factory MainData.fromJson(Map<String, dynamic> json) => MainData(
        currentPage: json["current_page"],
        data: json["data"] == null ? [] : List<BankHistory>.from(json["data"]!.map((x) => BankHistory.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": data == null ? [] : List<BankHistory>.from(data!.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
        "path": path,
      };
}

class BankHistory {
  int? id;
  String? userId;
  String? setupBankTransferId;
  String? accountHolder;
  String? accountNumber;
  String? amount;
  String? trx;
  String? adminFeedback;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? statusBadge;
  BankData? bank;
  GetTrx? trxData;
  List<UserData>? userData;
  BankHistory({
    this.id,
    this.userId,
    this.setupBankTransferId,
    this.accountHolder,
    this.accountNumber,
    this.amount,
    this.trx,
    this.userData,
    this.adminFeedback,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.statusBadge,
    this.bank,
    this.trxData,
  });

  factory BankHistory.fromJson(Map<String, dynamic> json) => BankHistory(
        id: json["id"],
        userId: json["user_id"].toString(),
        setupBankTransferId: json["setup_bank_transfer_id"].toString(),
        accountHolder: json["account_holder"] != null ? json["account_holder"].toString() : '',
        accountNumber: json["account_number"] != null ? json["account_number"].toString() : '',
        amount: json["amount"] != null ? json["amount"].toString() : '',
        trx: json["trx"].toString(),
        userData: json["user_data"] == null ? [] : List<UserData>.from(json["user_data"]!.map((x) => UserData.fromJson(x))),
        adminFeedback: json["admin_feedback"].toString(),
        status: json["status"].toString(),
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        statusBadge: json["status_badge"].toString(),
        bank: json["bank"] == null ? null : BankData.fromJson(json["bank"]),
        trxData: json["get_trx"] == null ? null : GetTrx.fromJson(json["get_trx"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "setup_bank_transfer_id": setupBankTransferId,
        "account_holder": accountHolder,
        "account_number": accountNumber,
        "amount": amount,
        "trx": trx,
        // "user_data": userData == null ? [] : List<UserData>.from(userData!.map((x) => x.toJson())),
        "admin_feedback": adminFeedback,
        "status": status,
        "created_at": createdAt?.toString(),
        "updated_at": updatedAt?.toString(),
        "status_badge": statusBadge,
        "bank": bank?.toJson(),
      };
}

class BankData {
  int? id;
  String? name;
  String? formId;
  String? status;
  String? image;
  String? createdAt;
  String? updatedAt;
  String? getImage;

  BankData({
    this.id,
    this.name,
    this.formId,
    this.status,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.getImage,
  });

  factory BankData.fromJson(Map<String, dynamic> json) => BankData(
        id: json["id"],
        name: json["name"],
        formId: json["form_id"].toString(),
        status: json["status"].toString(),
        image: json["image"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        getImage: json["get_image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "form_id": formId,
        "status": status,
        "image": image,
        "created_at": createdAt?.toString(),
        "updated_at": updatedAt?.toString(),
        "get_image": getImage,
      };
}

class UserData {
  String? name;
  String? type;
  dynamic value;

  UserData({
    this.name,
    this.type,
    this.value,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        name: json["name"],
        type: json["type"],
        value: json["value"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "type": type,
        "value": value,
      };
}

class GetTrx {
  int? id;
  String? setupDonationId; //
  String? userId; //
  String? userType;
  String? receiverId; //
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
  dynamic reference;
  String? hideIdentity; //
  String? createdAt;
  String? updatedAt;

  GetTrx({
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
  });

  factory GetTrx.fromJson(Map<String, dynamic> json) => GetTrx(
        id: json["id"],
        setupDonationId: json["setup_donation_id"].toString(),
        userId: json["user_id"].toString(),
        userType: json["user_type"].toString(),
        receiverId: json["receiver_id"].toString(),
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
        hideIdentity: json["hide_identity"].toString(),
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
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
      };
}
