
import 'dart:convert';

import 'package:viserpay/data/model/global/meassage_model.dart';

NotificationSettingsResponseModal userCheckResponseModalFromJson(String str) => NotificationSettingsResponseModal.fromJson(json.decode(str));

String userCheckResponseModalToJson(NotificationSettingsResponseModal data) => json.encode(data.toJson());

class NotificationSettingsResponseModal {
  String? remark;
  String? status;
  Message? message;
  Data? data;

  NotificationSettingsResponseModal({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory NotificationSettingsResponseModal.fromJson(Map<String, dynamic> json) => NotificationSettingsResponseModal(
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
  User? user;

  Data({
    this.user,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
      };
}

class User {
  int? id;
  String? firstname;
  String? lastname;
  String? username;
  String? email;
  String? countryCode;
  String? mobile;
  String? refBy;
  Address? address;
  String? image;
  String? status;
  String? kv;
  String? ev;
  String? sv;
  String? profileComplete;
  String? verCodeSendAt;
  String? ts;
  String? tv;
  String? tsc;
  //
  String? en;
  String? pn;
  String? allowPromotionalNotifications;
  //
  String? banReason;
  String? createdAt;
  String? updatedAt;
  String? getImage;

  User({
    this.id,
    this.firstname,
    this.lastname,
    this.username,
    this.email,
    this.countryCode,
    this.mobile,
    this.refBy,
    this.address,
    this.image,
    this.status,
    this.kv,
    this.ev,
    this.sv,
    this.profileComplete,
    this.verCodeSendAt,
    this.ts,
    this.tv,
    this.tsc,
    this.en,
    this.pn,
    this.allowPromotionalNotifications,
    this.banReason,
    this.createdAt,
    this.updatedAt,
    this.getImage,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        username: json["username"],
        email: json["email"],
        countryCode: json["country_code"].toString(),
        mobile: json["mobile"].toString(),
        address: json["address"] == null ? null : Address.fromJson(json["address"]),
        image: json["image"].toString(),
        tsc: json["tsc"] == null ? '' : json["tsc"].toString(),
        en: json["en"] == null ? '' : json["en"].toString(),
        pn: json["pn"] == null ? '' : json["pn"].toString(),
        allowPromotionalNotifications: json["is_allow_promotional_notify"] == null ? '' : json["is_allow_promotional_notify"].toString(),
        createdAt: json["created_at"] .toString(),
        updatedAt: json["updated_at"] .toString(),
        getImage: json["get_image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstname": firstname,
        "lastname": lastname,
        "username": username,
        "email": email,
        "country_code": countryCode,
        "mobile": mobile,
        "ref_by": refBy,
        "address": address?.toJson(),
        "image": image,
        "status": status,
        "kv": kv,
        "ev": ev,
        "sv": sv,
        "profile_complete": profileComplete,
        "ver_code_send_at": verCodeSendAt?.toString(),
        "ts": ts,
        "tv": tv,
        "tsc": tsc,
        "ban_reason": banReason,
        "created_at": createdAt?.toString(),
        "updated_at": updatedAt?.toString(),
        "get_image": getImage,
      };
}

class Address {
  String? address;
  String? state;
  String? zip;
  String? country;
  String? city;

  Address({
    this.address,
    this.state,
    this.zip,
    this.country,
    this.city,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        address: json["address"],
        state: json["state"],
        zip: json["zip"],
        country: json["country"],
        city: json["city"],
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "state": state,
        "zip": zip,
        "country": country,
        "city": city,
      };
}
