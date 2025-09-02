// ignore_for_file: prefer_null_aware_operators

import 'package:viserpay/data/model/global/meassage_model.dart';

class AddBankResponseModel {
  String? remark;
  String? status;
  Message? message;
  Data? data;

  AddBankResponseModel({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory AddBankResponseModel.fromJson(Map<String, dynamic> json) => AddBankResponseModel(
        remark: json["remark"],
        status: json["status"].toString(),
        message: json["message"] == null ? null : Message.fromJson(json["message"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  NewBank? banks;
  Data({
    this.banks,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        banks: json["bank"] == null ? null : NewBank.fromJson(json["bank"]),
      );
}

class NewBank {
  int? id;
  String? userId;
  String? name;
  String? accountNumber;
  String? bankId;
  String? status;
  String? createdAt;
  String? updatedAt;

  NewBank({
    this.id,
    this.userId,
    this.name,
    this.accountNumber,
    this.bankId,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory NewBank.fromJson(Map<String, dynamic> json) => NewBank(
        id: json["id"],
        userId: json["user_id"] == null ? null : json["user_id"].toString(),
        name: json["name"],
        bankId: json["bank_id"] == null ? null : json["bank_id"].toString(),
        status: json["status"].toString(),
        accountNumber: json["account_number"]!= null? json["account_number"].toString() : '',
        createdAt: json["created_at"] == null ? null : json["created_at"].toString(),
        updatedAt: json["updated_at"] == null ? null : json["updated_at"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "bank_id": bankId,
        "status": status,
        "created_at": createdAt?.toString(),
        "updated_at": updatedAt?.toString(),
      };
}
