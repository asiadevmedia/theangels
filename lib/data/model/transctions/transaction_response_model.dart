
import 'package:viserpay/data/model/global/meassage_model.dart';
import 'package:viserpay/data/model/global/receive_agent_model/receive_agent_model.dart';
import 'package:viserpay/data/model/paybill/paybill_history_model.dart';
import 'package:viserpay/data/model/recharge/recharge_data_response_modal.dart';

class TransactionResponseModel {
  TransactionResponseModel({
    String? remark,
    String? status,
    Message? message,
    MainData? data,
  }) {
    _remark = remark;
    _status = status;
    _message = message;
    _data = data;
  }

  TransactionResponseModel.fromJson(dynamic json) {
    _remark = json['remark'];
    _status = json['status'];
    _message = json['message'] != null ? Message.fromJson(json['message']) : null;
    _data = json['data'] != null ? MainData.fromJson(json['data']) : null;
  }
  String? _remark;
  String? _status;
  Message? _message;
  MainData? _data;

  String? get remark => _remark;
  String? get status => _status;
  Message? get message => _message;
  MainData? get data => _data;

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

class MainData {
  MainData({
    List<String>? operations,
    List<String>? times,
    Transactions? transactions,
    List<String>? remarks,
  }) {
    _operations = operations;
    _times = times;
    _transactions = transactions;
    _remarks = remarks;
  }

  MainData.fromJson(dynamic json) {
    _operations = json['operations'] != null ? json['operations'].cast<String>() : [];
    _times = json['times'] != null ? json['times'].cast<String>() : [];
    _transactions = json['transactions'] != null ? Transactions.fromJson(json['transactions']) : null;
    _remarks = json["remarks"] == null ? [] : json['remarks'].cast<String>();
  }
  List<String>? _operations;
  List<String>? _times;
  Transactions? _transactions;
  List<String>? _remarks;

  List<String>? get operations => _operations;
  List<String>? get times => _times;
  Transactions? get transactions => _transactions;
  List<String>? get remarks => _remarks;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['operations'] = _operations;
    map['times'] = _times;
    if (_transactions != null) {
      map['transactions'] = _transactions?.toJson();
    }
    return map;
  }
}

class Transactions {
  Transactions({List<Data>? data, String? nextPageUrl, String? path}) {
    _data = data;
    _nextPageUrl = nextPageUrl;
    _path = path;
  }

  Transactions.fromJson(dynamic json) {
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
    _nextPageUrl = json['next_page_url'] != null ? json['next_page_url'].toString() : "";
    _path = json['path'].toString();
  }

  List<Data>? _data;
  String? _nextPageUrl;
  String? _path;

  List<Data>? get data => _data;
  String? get nextPageUrl => _nextPageUrl;
  String? get path => _path;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    map['next_page_url'] = _nextPageUrl;
    map['path'] = _path;
    return map;
  }
}

class Data {
  Data({
    int? id,
    String? userId,
    String? userType,
    String? receiverId,
    String? receiverType,
    String? currencyId,
    String? walletId,
    String? beforeCharge,
    String? amount,
    String? charge,
    String? postBalance,
    String? trxType,
    String? chargeType,
    String? trx,
    String? details,
    String? remark,
    String? createdAt,
    String? updatedAt,
    String? apiDetails,
    User? receiverUser,
    User? receiverAgent,
    User? receiverMerchant,
    LatestMobileRecharge? mobileRecharge,
    DonationFor? donationFor,
    PayBilHistroy? utilitybill,
    RelatedTransaction? relatedTransaction,
  }) {
    _id = id;
    _userId = userId;
    _userType = userType;
    _receiverId = receiverId;
    _receiverType = receiverType;
    _currencyId = currencyId;
    _walletId = walletId;
    _beforeCharge = beforeCharge;
    _amount = amount;
    _charge = charge;
    _postBalance = postBalance;
    _trxType = trxType;
    _chargeType = chargeType;
    _trx = trx;
    _details = details;
    _remark = remark;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _apiDetails = apiDetails;

    _receiverUser = receiverUser;
    _receiverAgent = receiverAgent;
    _receiverMerchant = receiverMerchant;
    _mobileRecharge = mobileRecharge;
    _donationFor = donationFor;
    _utilitybill = utilitybill;
    _relatedTransaction = relatedTransaction;
  }

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['user_id'].toString();
    _userType = json['user_type'].toString();
    _receiverId = json['receiver_id'].toString();
    _receiverType = json['receiver_type'].toString();
    _currencyId = json['currency_id'].toString();
    _walletId = json['wallet_id'].toString();
    _beforeCharge = json['before_charge'] != null ? json['before_charge'].toString() : '';
    _amount = json['amount'] != null ? json['amount'].toString() : "";
    _charge = json['charge'] != null ? json['charge'].toString() : '';
    _postBalance = json['post_balance'] != null ? json['post_balance'].toString() : '';
    _trxType = json['trx_type'] != null ? json['trx_type'].toString() : '';
    _chargeType = json['charge_type'] != null ? json['charge_type'].toString() : '';
    _trx = json['trx'] != null ? json['trx'].toString() : '';
    _details = json['details'] != null ? json['details'].toString() : '';
    _remark = json['remark'] != null ? json['remark'].toString() : '';
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _apiDetails = json['apiDetails'].toString();
    _receiverUser = json['receiver_user'] != null ? User.fromJson(json['receiver_user']) : null;
    _receiverAgent = json['receiver_agent'] != null ? User.fromJson(json['receiver_agent']) : null;
    _receiverMerchant = json['receiver_merchant'] != null ? User.fromJson(json['receiver_merchant']) : null;
    _donationFor = json["donation_for"] == null ? null : DonationFor.fromJson(json["donation_for"]);
    _mobileRecharge = json["mobile_recharge"] == null ? null : LatestMobileRecharge.fromJson((json["mobile_recharge"]));
    _utilitybill = json["utility_bill"] == null ? null : PayBilHistroy.fromJson((json["utility_bill"]));
    _relatedTransaction = json["related_transaction"] == null ? null : RelatedTransaction.fromJson(json["related_transaction"]);
  }
  int? _id;
  String? _userId;
  String? _userType;
  String? _receiverId;
  String? _receiverType;
  String? _currencyId;
  String? _walletId;
  String? _beforeCharge;
  String? _amount;
  String? _charge;
  String? _postBalance;
  String? _trxType;
  String? _chargeType;
  String? _trx;
  String? _details;
  String? _remark;
  String? _createdAt;
  String? _updatedAt;
  String? _apiDetails;

  User? _receiverUser;
  User? _receiverAgent;
  User? _receiverMerchant;
  LatestMobileRecharge? _mobileRecharge;
  DonationFor? _donationFor;
  PayBilHistroy? _utilitybill;
  RelatedTransaction? _relatedTransaction;

  int? get id => _id;
  String? get userId => _userId;
  String? get userType => _userType;
  String? get receiverId => _receiverId;
  String? get receiverType => _receiverType;
  String? get currencyId => _currencyId;
  String? get walletId => _walletId;
  String? get beforeCharge => _beforeCharge;
  String? get amount => _amount;
  String? get charge => _charge;
  String? get postBalance => _postBalance;
  String? get trxType => _trxType;
  String? get chargeType => _chargeType;
  String? get trx => _trx;
  String? get details => _details;
  String? get remark => _remark;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get apiDetails => _apiDetails;

  User? get receiverUser => _receiverUser;
  User? get receiverAgent => _receiverAgent;
  User? get receiverMerchant => _receiverMerchant;

  LatestMobileRecharge? get mobileRecharge => _mobileRecharge;
  DonationFor? get donationFor => _donationFor;
  PayBilHistroy? get utilitybill => _utilitybill;
  RelatedTransaction? get relatedTransaction => _relatedTransaction;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['user_id'] = _userId;
    map['user_type'] = _userType;
    map['receiver_id'] = _receiverId;
    map['receiver_type'] = _receiverType;
    map['currency_id'] = _currencyId;
    map['wallet_id'] = _walletId;
    map['before_charge'] = _beforeCharge;
    map['amount'] = _amount;
    map['charge'] = _charge;
    map['post_balance'] = _postBalance;
    map['trx_type'] = _trxType;
    map['charge_type'] = _chargeType;
    map['trx'] = _trx;
    map['details'] = _details;
    map['remark'] = _remark;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['apiDetails'] = _apiDetails;

    if (_receiverUser != null) {
      map['receiver_user'] = _receiverUser?.toJson();
    }
    map['receiver_agent'] = _receiverAgent;
    map['receiver_merchant'] = _receiverMerchant;
    map['mobile_recharge'] = _mobileRecharge;
    return map;
  }
}

class DonationFor {
  int? id;
  String? name;
  String? address;
  String? image;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? getImage;

  DonationFor({
    this.id,
    this.name,
    this.address,
    this.image,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.getImage,
  });

  factory DonationFor.fromJson(Map<String, dynamic> json) => DonationFor(
        id: json["id"],
        name: json["name"],
        address: json["address"],
        image: json["image"],
        status: json["status"].toString(),
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        getImage: json["get_image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
        "image": image,
        "status": status,
        "created_at": createdAt?.toString(),
        "updated_at": updatedAt?.toString(),
        "get_image": getImage,
      };
}

class Address {
  Address({
    String? country,
    dynamic address,
    dynamic state,
    dynamic zip,
    dynamic city,
  }) {
    _country = country;
    _address = address;
    _state = state;
    _zip = zip;
    _city = city;
  }

  Address.fromJson(dynamic json) {
    _country = json['country'].toString();
    _address = json['address'].toString();
    _state = json['state'].toString();
    _zip = json['zip'].toString();
    _city = json['city'].toString();
  }
  String? _country;
  dynamic _address;
  dynamic _state;
  dynamic _zip;
  dynamic _city;

  String? get country => _country;
  dynamic get address => _address;
  dynamic get state => _state;
  dynamic get zip => _zip;
  dynamic get city => _city;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['country'] = _country;
    map['address'] = _address;
    map['state'] = _state;
    map['zip'] = _zip;
    map['city'] = _city;
    return map;
  }
}

class RemarkList {
  List<Remark>? remarks;

  RemarkList({
    this.remarks,
  });

  factory RemarkList.fromJson(Map<String, dynamic> json) => RemarkList(
        remarks: json["remarks"] == null ? [] : List<Remark>.from(json["remarks"]!.map((x) => Remark.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "remarks": remarks == null ? [] : List<dynamic>.from(remarks!.map((x) => x.toJson())),
      };
}

class Remark {
  String? remark;

  Remark({
    this.remark,
  });

  factory Remark.fromJson(Map<String, dynamic> json) => Remark(
        remark: json["remark"],
      );

  Map<String, dynamic> toJson() => {
        "remark": remark,
      };
}

class User {
  User({
    int? id,
    int? packageId,
    String? validity,
    dynamic telegramUsername,
    String? firstname,
    String? lastname,
    String? username,
    String? email,
    String? countryCode,
    String? mobile,
    String? refBy,
    String? pin,
    String? balance,
    String? image,
    String? getimage,
    String? isPinset,
    Address? address,
    String? status,
    String? ev,
    String? sv,
    dynamic verCode,
    dynamic verCodeSendAt,
    String? ts,
    String? tv,
    dynamic tsc,
    String? regStep,
    String? buyFreePackage,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _packageId = packageId;
    _validity = validity;
    _telegramUsername = telegramUsername;
    _firstname = firstname;
    _lastname = lastname;
    _username = username;
    _email = email;
    _countryCode = countryCode;
    _mobile = mobile;
    _pin = pin;
    _balance = balance;
    _image = image;
    _getimage = getimage;
    _isPinset = isPinset;
    _address = address;
    _status = status;
    _ev = ev;
    _sv = sv;

    _ts = ts;
    _tv = tv;
    _tsc = tsc;
    _regStep = regStep;
    _buyFreePackage = buyFreePackage;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  User.fromJson(dynamic json) {
    _id = json['id'];
    _packageId = json['package_id'];
    _validity = json['validity'];
    _telegramUsername = json['telegram_username'];
    _firstname = json['firstname'];
    _lastname = json['lastname'];
    _username = json['username'];
    _email = json['email'];
    _pin = json['pin'].toString();
    _countryCode = json['country_code'].toString();
    _mobile = json['mobile'].toString();
    _balance = json['balance'].toString();
    _image = json['image'];
    _getimage = json['get_image'] ?? '';
    _isPinset = json['is_pin_set'] != null ? json['is_pin_set'].toString() : "0";
    _address = json['address'] != null ? Address.fromJson(json['address']) : null;
    _status = json['status'].toString();
    _ev = json['ev'].toString();
    _sv = json['sv'].toString();
    _regStep = json['profile_complete'].toString();
    _ts = json['ts'].toString();
    _tv = json['tv'].toString();
    _tsc = json['tsc'].toString();
    _buyFreePackage = json['buy_free_package'].toString();
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  int? _id;
  int? _packageId;
  String? _validity;
  dynamic _telegramUsername;
  String? _firstname;
  String? _lastname;
  String? _username;
  String? _email;
  String? _countryCode;
  String? _mobile;
  String? _pin;
  String? _balance;
  String? _image;
  String? _getimage;
  String? _isPinset;
  Address? _address;
  String? _status;
  String? _ev;
  String? _sv;
  String? _regStep;
  String? _ts;
  String? _tv;
  dynamic _tsc;
  String? _buyFreePackage;
  String? _createdAt;
  String? _updatedAt;

  int? get id => _id;
  int? get packageId => _packageId;
  String? get validity => _validity;
  dynamic get telegramUsername => _telegramUsername;
  String? get firstname => _firstname;
  String? get lastname => _lastname;
  String? get username => _username;
  String? get email => _email;
  String? get countryCode => _countryCode;
  String? get mobile => _mobile;
  String? get pin => _pin;

  String? get balance => _balance;
  String? get image => _image;
  String? get getimage => _getimage;
  String? get isPinSet => _isPinset;
  Address? get address => _address;
  String? get status => _status;
  String? get ev => _ev;
  String? get sv => _sv;

  String? get ts => _ts;
  String? get tv => _tv;
  dynamic get tsc => _tsc;
  dynamic get regStep => _regStep;
  String? get buyFreePackage => _buyFreePackage;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['package_id'] = _packageId;
    map['validity'] = _validity;
    map['telegram_username'] = _telegramUsername;
    map['firstname'] = _firstname;
    map['lastname'] = _lastname;
    map['username'] = _username;
    map['email'] = _email;
    map['country_code'] = _countryCode;
    map['mobile'] = _mobile;

    map['balance'] = _balance;
    map['image'] = _image;
    map['profile_complete'] = _regStep;
    if (_address != null) {
      map['address'] = _address?.toJson();
    }
    map['status'] = _status;
    map['ev'] = _ev;
    map['sv'] = _sv;

    map['ts'] = _ts;
    map['tv'] = _tv;
    map['tsc'] = _tsc;
    map['buy_free_package'] = _buyFreePackage;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }
}

class RelatedTransaction {
  int? id;
  int? setupDonationId;
  int? userId;
  String? userType;
  int? receiverId;
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
  dynamic reference;
  int? hideIdentity;
  String? createdAt;
  String? updatedAt;
  ReceiverUser? user;

  RelatedTransaction({
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
    this.user,
  });

  factory RelatedTransaction.fromJson(Map<String, dynamic> json) {
    return RelatedTransaction(
      id: json["id"],
      setupDonationId: json["setup_donation_id"],
      userId: json["user_id"],
      userType: json["user_type"],
      receiverId: json["receiver_id"],
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
      hideIdentity: json["hide_identity"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
      user: json["user"] == null ? null : ReceiverUser.fromJson(json["user"]),
    );
  }

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
        "user": user?.toJson(),
      };
}
