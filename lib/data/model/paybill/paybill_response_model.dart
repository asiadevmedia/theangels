import 'dart:convert';

import 'package:viserpay/core/helper/string_format_helper.dart';
import 'package:viserpay/data/model/global/meassage_model.dart';
import 'package:viserpay/data/model/global/userdata/global_user_data.dart';
import 'package:viserpay/data/model/paybill/paybill_history_model.dart';

PaybillResponseModel paybillResponseModelFromJson(String str) => PaybillResponseModel.fromJson(json.decode(str));

String paybillResponseModelToJson(PaybillResponseModel data) => json.encode(data.toJson());

class PaybillResponseModel {
  String? remark;
  String? status;
  Message? message;
  Data? data;

  PaybillResponseModel({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory PaybillResponseModel.fromJson(Map<String, dynamic> json) => PaybillResponseModel(
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
  // PayBillCharge? payBillCharge;
  List<Utility>? utility;
  List<PayBilHistroy>? latestPayBillHistory;

  Data({
    this.otpType,
    this.currentBalance,
    // this.payBillCharge,
    this.utility,
    this.latestPayBillHistory,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        otpType: json["otp_type"] == null ? [] : List<String>.from(json["otp_type"]!.map((x) => x)),
        currentBalance: json["current_balance"] != null ?json["current_balance"].toString().removeComma() : '',
        // payBillCharge: json["pay_bill_charge"] == null ? null : PayBillCharge.fromJson(json["pay_bill_charge"]),
        utility: json["utility"] == null ? [] : List<Utility>.from(json["utility"]!.map((x) => Utility.fromJson(x))),
        latestPayBillHistory: json["latest_pay_bill_history"] == null
            ? []
            : List<PayBilHistroy>.from(
                json["latest_pay_bill_history"]!.map((x) => PayBilHistroy.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
        "otp_type": otpType == null ? [] : List<dynamic>.from(otpType!.map((x) => x)),
        "current_balance": currentBalance,
        // "pay_bill_charge": payBillCharge?.toJson(),
        "utility": utility == null ? [] : List<dynamic>.from(utility!.map((x) => x.toJson())),
        "latest_pay_bill_history": latestPayBillHistory == null ? [] : List<dynamic>.from(latestPayBillHistory!.map((x) => x)),
      };
}

class Utility {
  int? id;
  String? name;
  String? fixedCharge;
  String? percentCharge;
  String? formId;
  String? image;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? getImage;
  GlobalUserDetailsData? form;

  Utility({
    this.id,
    this.name,
    this.fixedCharge,
    this.percentCharge,
    this.formId,
    this.image,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.getImage,
    this.form,
  });

  factory Utility.fromJson(Map<String, dynamic> json) => Utility(
        id: json["id"],
        name: json["name"],
        fixedCharge: json["fixed_charge"] != null ? json["fixed_charge"].toString() : '',
        percentCharge: json["percent_charge"] != null ? json["percent_charge"].toString() : '',
        formId: json["form_id"].toString(),
        image: json["image"],
        status: json["status"].toString(),
        createdAt: json["created_at"].toString(),
        updatedAt: json["updated_at"].toString(),
        getImage: json["get_image"],
        form: json["form"] == null ? null : GlobalUserDetailsData.fromJson(json["form"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "form_id": formId,
        "image": image,
        "status": status,
        "created_at": createdAt?.toString(),
        "updated_at": updatedAt?.toString(),
        "get_image": getImage,
        "form": form?.toJson(),
      };
}

class PayBillCharge {
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

  PayBillCharge({
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

  factory PayBillCharge.fromJson(Map<String, dynamic> json) => PayBillCharge(
        id: json["id"],
        slug: json["slug"],
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
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
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

class PaybillHistoryModel {
  String? userId;
  String? setupUtilityBillId;
  String? amount;
  String? trx;
  List<UserData>? userData;
  String? updatedAt;
  String? createdAt;
  int? id;
  String? status;
  String? statusBadge;
  SetupUtilityBill? setupUtilityBill;

  PaybillHistoryModel({this.userId, this.setupUtilityBillId, this.amount, this.trx, this.userData, this.updatedAt, this.createdAt, this.id, this.statusBadge, this.setupUtilityBill, this.status});

  factory PaybillHistoryModel.fromJson(Map<String, dynamic> json) => PaybillHistoryModel(
        userId: json['user_id'] == null ? '' : json['user_id'].toString(),
        setupUtilityBillId: json['setup_utility_bill_id'] == null ? '' : json['setup_utility_bill_id'].toString(),
        amount: json['amount'] != null ? json['amount'].toString() : '',
        trx: json['trx'],
        userData: json["user_data"] == null ? [] : List<UserData>.from(json["user_data"]!.map((x) => UserData.fromJson(x))),
        updatedAt: json['updated_at'],
        createdAt: json['created_at'],
        id: json['id'],
        status: json['status'] == null ? "0" : json['status'].toString(),
        statusBadge: json['status_badge'].toString(),
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
    image = json['image'].toString();
    status = json['status'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    getImage = json['get_image'].toString();
  }
}
