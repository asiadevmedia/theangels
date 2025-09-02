import '../auth/sign_up_model/registration_response_model.dart';

class QrCodeSubmitScanResponseModel {
  QrCodeSubmitScanResponseModel({
    String? remark,
    String? status,
    Message? message,
    Data? data,
  }) {
    _remark = remark;
    _status = status;
    _message = message;
    _data = data;
  }

  QrCodeSubmitScanResponseModel.fromJson(dynamic json) {
    _remark = json['remark'];
    _status = json['status'];
    _message = json['message'] != null ? Message.fromJson(json['message']) : null;
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  String? _remark;
  String? _status;
  Message? _message;
  Data? _data;

  String? get remark => _remark;
  String? get status => _status;
  Message? get message => _message;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['remark'] = _remark;
    map['status'] = _status;
    if (_message != null) {
      map['message'] = _message?.toJson();
    }
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }
}

class Data {
  Data({
    String? userType,
    UserData? userData,
    List<TransactionCharge>? transactionChargeList,
  }) {
    _userType = userType;
    _userData = userData;
    _transactionChargeList = transactionChargeList;
  }

  Data.fromJson(dynamic json) {
    _userType = json['user_type'];
    _userData = json['user_data'] != null ? UserData.fromJson(json['user_data']) : null;
    _transactionChargeList = json["transaction_charge"] == null ? [] : List<TransactionCharge>.from(json["transaction_charge"]!.map((x) => TransactionCharge.fromJson(x)));
  }
  String? _userType;
  UserData? _userData;
  List<TransactionCharge>? _transactionChargeList;

  String? get userType => _userType;
  UserData? get userData => _userData;
  List<TransactionCharge>? get transactionChargeList => _transactionChargeList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_type'] = _userType;
    if (_userData != null) {
      map['user_data'] = _userData?.toJson();
    }
    return map;
  }
}

class UserData {
  UserData({
    int? id,
    String? firstname,
    String? lastname,
    String? username,
    String? email,
    String? countryCode,
    String? mobile,
    String? refBy,
    String? balance,
    String? password,
    String? image,
    Address? address,
    String? status,
    String? kv,
    String? ev,
    String? sv,
    String? profileComplete,
    String? verCode,
    String? verCodeSendAt,
    String? ts,
    String? tv,
    dynamic tsc,
    dynamic banReason,
    dynamic rememberToken,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _firstname = firstname;
    _lastname = lastname;
    _username = username;
    _email = email;
    _countryCode = countryCode;
    _mobile = mobile;
    _refBy = refBy;
    _balance = balance;
    _password = password;
    _image = image;
    _address = address;
    _status = status;
    _kv = kv;
    _ev = ev;
    _sv = sv;
    _profileComplete = profileComplete;
    _verCode = verCode;
    _verCodeSendAt = verCodeSendAt;
    _ts = ts;
    _tv = tv;
    _tsc = tsc;
    _banReason = banReason;
    _rememberToken = rememberToken;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  UserData.fromJson(dynamic json) {
    _id = json['id'];
    _firstname = json['firstname'];
    _lastname = json['lastname'];
    _username = json['username'];
    _email = json['email'];
    _countryCode = json['country_code'].toString();
    _mobile = json['mobile'].toString();
    _refBy = json['ref_by'].toString();
    _balance = json['balance'].toString();
    _password = json['password'].toString();
    _image = json['image'];
    _address = json['address'] != null ? Address.fromJson(json['address']) : null;
    _status = json['status'].toString();
    _kv = json['kv'].toString();
    _ev = json['ev'].toString();
    _sv = json['sv'].toString();
    _profileComplete = json['profile_complete'].toString();
    _verCode = json['ver_code'].toString();
    _verCodeSendAt = json['ver_code_send_at'];
    _ts = json['ts'].toString();
    _tv = json['tv'].toString();
    _tsc = json['tsc'].toString();
    _banReason = json['ban_reason'].toString();
    _rememberToken = json['remember_token'].toString();
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  int? _id;
  String? _firstname;
  String? _lastname;
  String? _username;
  String? _email;
  String? _countryCode;
  String? _mobile;
  String? _refBy;
  String? _balance;
  String? _password;
  String? _image;
  Address? _address;
  String? _status;
  String? _kv;
  String? _ev;
  String? _sv;
  String? _profileComplete;
  String? _verCode;
  String? _verCodeSendAt;
  String? _ts;
  String? _tv;
  dynamic _tsc;
  dynamic _banReason;
  dynamic _rememberToken;
  String? _createdAt;
  String? _updatedAt;

  int? get id => _id;
  String? get firstname => _firstname;
  String? get lastname => _lastname;
  String? get username => _username;
  String? get email => _email;
  String? get countryCode => _countryCode;
  String? get mobile => _mobile;
  String? get refBy => _refBy;
  String? get balance => _balance;
  String? get password => _password;
  String? get image => _image;
  Address? get address => _address;
  String? get status => _status;
  String? get kv => _kv;
  String? get ev => _ev;
  String? get sv => _sv;
  String? get profileComplete => _profileComplete;
  String? get verCode => _verCode;
  String? get verCodeSendAt => _verCodeSendAt;
  String? get ts => _ts;
  String? get tv => _tv;
  dynamic get tsc => _tsc;
  dynamic get banReason => _banReason;
  dynamic get rememberToken => _rememberToken;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['firstname'] = _firstname;
    map['lastname'] = _lastname;
    map['username'] = _username;
    map['email'] = _email;
    map['country_code'] = _countryCode;
    map['mobile'] = _mobile;
    map['ref_by'] = _refBy;
    map['balance'] = _balance;
    map['password'] = _password;
    map['image'] = _image;
    if (_address != null) {
      map['address'] = _address?.toJson();
    }
    map['status'] = _status;
    map['kv'] = _kv;
    map['ev'] = _ev;
    map['sv'] = _sv;
    map['profile_complete'] = _profileComplete;
    map['ver_code'] = _verCode;
    map['ver_code_send_at'] = _verCodeSendAt;
    map['ts'] = _ts;
    map['tv'] = _tv;
    map['tsc'] = _tsc;
    map['ban_reason'] = _banReason;
    map['remember_token'] = _rememberToken;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }
}

class TransactionCharge {
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

  TransactionCharge({
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

  factory TransactionCharge.fromJson(Map<String, dynamic> json) => TransactionCharge(
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
