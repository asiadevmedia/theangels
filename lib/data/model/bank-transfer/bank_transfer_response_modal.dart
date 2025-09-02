
import 'package:viserpay/core/helper/string_format_helper.dart';
import 'package:viserpay/data/model/global/meassage_model.dart';
import 'package:viserpay/data/model/global/userdata/global_user_data.dart';

class BankTransferResponseModal {
  String? remark;
  String? status;
  Message? message;
  Data? data;

  BankTransferResponseModal({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory BankTransferResponseModal.fromJson(Map<String, dynamic> json) => BankTransferResponseModal(
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
  List<String>? otpType;
  String? currentBalance;
  BankTransferCharge? bankTransferCharge;
  List<Bank>? banks;
  List<MyAddedBankModel>? myAddedBanks;
  Data({
    this.otpType,
    this.currentBalance,
    this.bankTransferCharge,
    this.banks,
    this.myAddedBanks,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        otpType: json["otp_type"] == null ? [] : List<String>.from(json["otp_type"]!.map((x) => x)),
        currentBalance: json["current_balance"] != null?json["current_balance"].toString().removeComma() : '',
        bankTransferCharge: json["bank_transfer_charge"] == null ? null : BankTransferCharge.fromJson(json["bank_transfer_charge"]),
        banks: json["banks"] == null ? [] : List<Bank>.from(json["banks"]!.map((x) => Bank.fromJson(x))),
        myAddedBanks: json["my_added_banks"] == null
            ? []
            : List<MyAddedBankModel>.from(
                json["my_added_banks"]!.map(
                  (x) => MyAddedBankModel.fromJson(x),
                ),
              ),
      );

  Map<String, dynamic> toJson() => {
        "otp_type": otpType == null ? [] : List<dynamic>.from(otpType!.map((x) => x)),
        "current_balance": currentBalance,
        "bank_transfer_charge": bankTransferCharge?.toJson(),
        "banks": banks == null ? [] : List<dynamic>.from(banks!.map((x) => x.toJson())),
        "my_added_banks": myAddedBanks == null ? [] : List<dynamic>.from(myAddedBanks!.map((x) => x)),
      };
}

class Bank {
  int? id;
  String? name;
  String? formId;
  String? status;
  String? getImage;
  String? createdAt;
  String? updatedAt;
  GlobalUserDetailsData? form;

  Bank({
    this.id,
    this.name,
    this.formId,
    this.status,
    this.getImage,
    this.createdAt,
    this.updatedAt,
    this.form,
  });

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
        id: json["id"],
        name: json["name"],
        formId: json["form_id"].toString(),
        status: json["status"].toString(),
        getImage: json["get_image"],
        createdAt: json["created_at"] ,
        updatedAt: json["updated_at"] ,
        form: json["form"] == null ? null : GlobalUserDetailsData.fromJson(json["form"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "form_id": formId,
        "status": status,
        "created_at": createdAt?.toString(),
        "updated_at": updatedAt?.toString(),
        "form": form?.toJson(),
      };
}

class BankTransferCharge {
  int? id;
  String? slug;
  String? fixedCharge;
  String? percentCharge;
  String? minLimit;
  String? maxLimit;
  String? agentCommissionFixed;
  String? agentCommissionPercent;
  String? merchantFixedCharge;
  String? merchantPercentCharge;
  String? monthlyLimit;
  String? dailyLimit;
  String? dailyRequestAcceptLimit;
  String? cap;
  String? createdAt;
  String? updatedAt;

  BankTransferCharge({
    this.id,
    this.slug,
    this.fixedCharge,
    this.percentCharge,
    this.minLimit,
    this.maxLimit,
    this.agentCommissionFixed,
    this.agentCommissionPercent,
    this.merchantFixedCharge,
    this.merchantPercentCharge,
    this.monthlyLimit,
    this.dailyLimit,
    this.dailyRequestAcceptLimit,
    this.cap,
    this.createdAt,
    this.updatedAt,
  });

  factory BankTransferCharge.fromJson(Map<String, dynamic> json) => BankTransferCharge(
        id: json["id"],
        slug: json["slug"].toString(),
        fixedCharge: json["fixed_charge"].toString(),
        percentCharge: json["percent_charge"].toString(),
        minLimit: json["min_limit"].toString(),
        maxLimit: json["max_limit"].toString(),
        agentCommissionFixed: json["agent_commission_fixed"].toString(),
        agentCommissionPercent: json["agent_commission_percent"].toString(),
        merchantFixedCharge: json["merchant_fixed_charge"].toString(),
        merchantPercentCharge: json["merchant_percent_charge"].toString(),
        monthlyLimit: json["monthly_limit"].toString(),
        dailyLimit: json["daily_limit"].toString(),
        dailyRequestAcceptLimit: json["daily_request_accept_limit"].toString(),
        cap: json["cap"].toString(),
        createdAt: json["created_at"] ,
        updatedAt: json["updated_at"] ,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "slug": slug,
        "fixed_charge": fixedCharge,
        "percent_charge": percentCharge,
        "min_limit": minLimit,
        "max_limit": maxLimit,
        "agent_commission_fixed": agentCommissionFixed,
        "agent_commission_percent": agentCommissionPercent,
        "merchant_fixed_charge": merchantFixedCharge,
        "merchant_percent_charge": merchantPercentCharge,
        "monthly_limit": monthlyLimit,
        "daily_limit": dailyLimit,
        "daily_request_accept_limit": dailyRequestAcceptLimit,
        "cap": cap,
        "created_at": createdAt?.toString(),
        "updated_at": updatedAt?.toString(),
      };
}

class MyAddedBankModel {
  int? id;
  String? userId;
  String? name;
  String? accountNumber;
  String? accountHolder;
  String? bankId;
  String? status;
  String? createdAt;
  String? updatedAt;
  Bank? bank;
  MyAddedBankModel({
    this.id,
    this.userId,
    this.name,
    this.accountNumber,
    this.accountHolder,
    this.bankId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.bank,
  });

  factory MyAddedBankModel.fromJson(Map<String, dynamic> json) => MyAddedBankModel(
        id: json["id"],
        userId: json["user_id"].toString(),
        name: json["name"],
        bankId: json["bank_id"].toString(),
        status: json["status"].toString(),
        accountNumber: json["account_number"].toString(),
        accountHolder: json["account_holder"].toString(),
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        bank: json["bank"] == null ? null : Bank.fromJson(json["bank"]),
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
