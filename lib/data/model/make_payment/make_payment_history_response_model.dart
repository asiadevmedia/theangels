// To parse this JSON data, do
//
//     final sendMoneyHistoryResponseModel = sendMoneyHistoryResponseModelFromJson(jsonString);


import 'package:viserpay/data/model/global/meassage_model.dart';
import 'package:viserpay/data/model/make_payment/make_payment_response_modal.dart';

class MakePaymentHistoryResponseModel {
  String? remark;
  String? status;
  Message? message;
  Data? data;

  MakePaymentHistoryResponseModel({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory MakePaymentHistoryResponseModel.fromJson(Map<String, dynamic> json) => MakePaymentHistoryResponseModel(
        remark: json["remark"],
        status: json["status"],
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
  History? history;

  Data({
    this.history,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        history: json["history"] == null ? null : History.fromJson(json["history"]),
      );

  Map<String, dynamic> toJson() => {
        "history": history?.toJson(),
      };
}

class History {
  List<LatestMakePaymentHistory>? data;
  String? nextPageUrl;

  History({
    this.data,
    this.nextPageUrl,
  });

  factory History.fromJson(Map<String, dynamic> json) => History(
        data: json["data"] == null ? [] : List<LatestMakePaymentHistory>.from(json["data"]!.map((x) => LatestMakePaymentHistory.fromJson(x))),
        nextPageUrl: json["next_page_url"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
      };
}
