// ignore_for_file: prefer_null_aware_operators

import 'package:viserpay/data/model/global/meassage_model.dart';

class PaybillHistoryResponseModel {
  String? remark;
  String? status;
  Message? message;
  Data? data;

  PaybillHistoryResponseModel({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory PaybillHistoryResponseModel.fromJson(Map<String, dynamic> json) => PaybillHistoryResponseModel(
        remark: json["remark"],
        status: json["status"].toString(),
        message: json["message"] == null ? null : Message.fromJson(json["message"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  String? filePath;
  History? history;
  Data({
    this.filePath,
    this.history,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        filePath: json["file_path"].toString(),
        history: json["history"] == null ? null : History.fromJson(json["history"]),
      );
}

class History {
  List<PayBilHistroy>? playbillhistory;
  String? nextPageUrl;

  History({
    this.playbillhistory,
    this.nextPageUrl,
  });

  factory History.fromJson(Map<String, dynamic> json) => History(
        nextPageUrl: json["next_page_url"] == null ? 'null' : json["current_page"].toString(),
        playbillhistory: json["data"] == null
            ? []
            : List<PayBilHistroy>.from(
                json["data"]!.map((x) => PayBilHistroy.fromJson(x)),
              ),
      );
}

class PayBilHistroy {
  String? userId;
  String? setupUtilityBillId;
  String? amount;
  String? trx;
  List<UserData>? userData;
  String? adminFeedback;
  String? updatedAt;
  String? createdAt;
  int? id;
  String? statusBadge;
  String? status;
  SetupUtilityBill? setupUtilityBill;
  GetTrx? transaction;

  PayBilHistroy({
    this.userId,
    this.status,
    this.setupUtilityBillId,
    this.amount,
    this.trx,
    this.userData,
    this.updatedAt,
    this.createdAt,
    this.id,
    this.adminFeedback,
    this.statusBadge,
    this.setupUtilityBill,
    this.transaction,
  });

  factory PayBilHistroy.fromJson(Map<String, dynamic> json) => PayBilHistroy(
        userId: json['user_id'] == null ? '' : json['user_id'].toString(),
        setupUtilityBillId: json['setup_utility_bill_id'] == null ? '' : json['setup_utility_bill_id'].toString(),
        amount: json['amount'].toString(),
        status: json['status'].toString(),
        trx: json['trx'],
        adminFeedback: json['admin_feedback'] != null ? json['admin_feedback'].toString() : '',
        userData: json["user_data"] == null ? [] : List<UserData>.from(json["user_data"]!.map((x) => UserData.fromJson(x))),
        updatedAt: json['updated_at'],
        createdAt: json['created_at'],
        id: json['id'],
        statusBadge: json['status_badge'].toString(),
        setupUtilityBill: json['setup_utility_bill'] != null ? SetupUtilityBill.fromJson(json['setup_utility_bill']) : null,
        transaction: json['get_trx'] != null ? GetTrx.fromJson(json['get_trx']) : null,
      );
}

class UserData {
  String? name;
  String? type;
  dynamic value;

  UserData({this.name, this.type, this.value});

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        name: json['name'],
        type: json['type'],
        value: json['value'] != null ? json['value'].toString() : "",
      );
}

class SetupUtilityBill {
  int? id;
  String? name;
  String? formId;
  String? image;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? getImage;

  SetupUtilityBill({this.id, this.name, this.formId, this.image, this.status, this.createdAt, this.updatedAt, this.getImage});

  factory SetupUtilityBill.fromJson(Map<String, dynamic> json) => SetupUtilityBill(
        id: json['id'],
        name: json['name'],
        formId: json['form_id'].toString(),
        image: json['image'],
        status: json['status'].toString(),
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        getImage: json['get_image'],
      );
}

class GetTrx {
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
        receiverType: json["receiver_type"].toString(),
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
