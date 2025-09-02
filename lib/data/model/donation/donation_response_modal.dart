import 'dart:convert';

import 'package:viserpay/core/helper/string_format_helper.dart';
import 'package:viserpay/data/model/global/meassage_model.dart';

DonationResponseModal cashOutResponseModalFromJson(String str) => DonationResponseModal.fromJson(json.decode(str));

String cashOutResponseModalToJson(DonationResponseModal data) => json.encode(data.toJson());

class DonationResponseModal {
  String? remark;
  String? status;
  Message? message;
  Data? data;

  DonationResponseModal({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory DonationResponseModal.fromJson(Map<String, dynamic> json) => DonationResponseModal(
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
  List<DonationOrganization>? organizations;

  Data({
    this.otpType,
    this.currentBalance,
    this.organizations,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        otpType: json["otp_type"] == null ? [] : List<String>.from(json["otp_type"]!.map((x) => x)),
        currentBalance: json["current_balance"] != null ? json["current_balance"].toString().removeComma() : "",
        organizations: json["setup_donations"] == null
            ? []
            : List<DonationOrganization>.from(
                json["setup_donations"]!.map(
                  (x) => DonationOrganization.fromJson(x),
                ),
              ),
      );

  Map<String, dynamic> toJson() => {
        "otp_type": otpType == null ? [] : List<dynamic>.from(otpType!.map((x) => x)),
        "current_balance": currentBalance,
        "setup_donations": organizations == null ? [] : List<dynamic>.from(organizations!.map((x) => x.toJson())),
      };
}

class DonationOrganization {
  int? id;
  String? name;
  String? address;
  String? image;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? getImage;

  DonationOrganization({
    this.id,
    this.name,
    this.address,
    this.image,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.getImage,
  });

  factory DonationOrganization.fromJson(Map<String, dynamic> json) => DonationOrganization(
        id: json["id"],
        name: json["name"],
        address: json["details"] ?? '',
        image: json["image"],
        status: json["status"].toString(),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        getImage: json["get_image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
        "image": image,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "get_image": getImage,
      };
}
