
class ReceiverUser {
  int? id;
  String? firstname;
  String? lastname;
  String? username;
  String? email;
  String? countryCode;
  String? mobile;
  String? refBy;
  AddressClass? address;
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
  String? banReason;
  String? createdAt;
  String? updatedAt;
  String? getImage;

  ReceiverUser({
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
    this.banReason,
    this.createdAt,
    this.updatedAt,
    this.getImage,
  });

  factory ReceiverUser.fromJson(Map<String, dynamic> json) => ReceiverUser(
        id: json["id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        username: json["username"],
        email: json["email"],
        countryCode: json["country_code"].toString(),
        mobile: json["mobile"].toString(),
        refBy: json["ref_by"].toString(),
        address: json["address"] == null ? null : AddressClass.fromJson(json["address"]),
        image: json["image"].toString(),
        status: json["status"].toString(),
        kv: json["kv"].toString(),
        ev: json["ev"].toString(),
        sv: json["sv"].toString(),
        profileComplete: json["profile_complete"].toString(),
        verCodeSendAt: json["ver_code_send_at"] .toString(),
        ts: json["ts"].toString(),
        tv: json["tv"].toString(),
        tsc: json["tsc"].toString(),
        banReason: json["ban_reason"].toString(),
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

class AddressClass {
  String? address;
  String? state;
  String? zip;
  String? country;
  String? city;

  AddressClass({
    this.address,
    this.state,
    this.zip,
    this.country,
    this.city,
  });

  factory AddressClass.fromJson(Map<String, dynamic> json) => AddressClass(
        address: json["address"],
        state: json["state"],
        zip: json["zip"].toString(),
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
