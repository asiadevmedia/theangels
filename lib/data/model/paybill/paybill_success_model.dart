
import 'package:viserpay/data/model/global/meassage_model.dart';

class PaybillSuccessResponseModel {
  String? remark;
  String? status;
  Message? message;
  Data? data;

  PaybillSuccessResponseModel({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory PaybillSuccessResponseModel.fromJson(Map<String, dynamic> json) => PaybillSuccessResponseModel(
        remark: json["remark"],
        status: json["status"].toString(),
        message: json["message"] == null ? null : Message.fromJson(json["message"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  UtilityBill? utility;
  PaybillTransaction? transaction;
  String? actionID;

  Data({
    this.utility,
    this.transaction,
    this.actionID,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    actionID: json["action_id"] == null ? 'null' : json["action_id"].toString(),
    utility: json["utility_bill"] == null ? null : UtilityBill.fromJson(json["utility_bill"]),
    transaction: json["transaction"] == null ? null : PaybillTransaction.fromJson(json["transaction"]),
  );
}

class UtilityBill {
  String? userId;
  String? setupUtilityBillId;
  String? amount;
  String? trx;
  List<UserData>? userData;
  String? updatedAt;
  String? createdAt;
  int? id;
  String? statusBadge;
  SetupUtilityBill? setupUtilityBill;

  UtilityBill({this.userId, this.setupUtilityBillId, this.amount, this.trx, this.userData, this.updatedAt, this.createdAt, this.id, this.statusBadge, this.setupUtilityBill});

  factory UtilityBill.fromJson(Map<String, dynamic> json) => UtilityBill(
    userId: json['user_id'] == null ? '' : json['user_id'].toString(),
    setupUtilityBillId: json['setup_utility_bill_id'] == null ? '' : json['setup_utility_bill_id'].toString(),
    amount: json['amount'],
    trx: json['trx'],
    userData: json["user_data"] == null ? [] : List<UserData>.from(json["user_data"]!.map((x) => UserData.fromJson(x))),
    updatedAt: json['updated_at'],
    createdAt: json['created_at'],
    id: json['id'],
    statusBadge: json['status_badge'],
    setupUtilityBill: json['setup_utility_bill'] != null ? SetupUtilityBill.fromJson(json['setup_utility_bill']) : null,
  );
}

class UserData {
  String? name;
  String? type;
  dynamic value;

  UserData({this.name, this.type, this.value});

  UserData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    value = json['value'];
  }
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

  SetupUtilityBill.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    formId = json['form_id'].toString();
    image = json['image'];
    status = json['status'].toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    getImage = json['get_image'];
  }
}

class PaybillTransaction {
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

  PaybillTransaction({this.userId, this.userType, this.beforeCharge, this.amount, this.postBalance, this.charge, this.chargeType, this.trxType, this.remark, this.details, this.receiverId, this.receiverType, this.trx, this.updatedAt, this.createdAt, this.id});

  factory PaybillTransaction.fromJson(Map<String, dynamic> json) => PaybillTransaction(
      userId: json["user_id"].toString(),
      userType: json['user_type'].toString(),
      beforeCharge: json["before_charge"] == '' ? null : json["before_charge"].toString(),
      amount: json["amount"] == null ? '' : json["amount"]?.toString(),
      postBalance: json["post_balance"] == null ? '' : json["post_balance"]?.toString(),
      charge: json["charge"] == null ? '' : json["charge"].toString(),
      chargeType: json['charge_type'].toString(),
      trxType: json['trx_type'].toString(),
      remark: json['remark'].toString(),
      details: json['details'].toString(),
      receiverId: json["receiver_id"].toString(),
      receiverType: json['receiver_type'].toString(),
      trx: json['trx'].toString(),
      updatedAt: json['updated_at'],
      createdAt: json['created_at'],
      id: json['id'],
    );
}
