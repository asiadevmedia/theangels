import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserContactModel {
  String name;
  String number;
  String? image;
  UserContactModel({
    required this.name,
    required this.number,
    this.image,
  });

  UserContactModel copyWith({
    String? name,
    String? number,
  }) {
    return UserContactModel(name: name ?? this.name, number: number ?? this.number, image: image ?? '');
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'name': name, 'number': number, 'image': image};
  }

  factory UserContactModel.fromJson(Map<String, dynamic> map) {
    return UserContactModel(
      name: map['name'] as String,
      number: map['number'] as String,
      image: map['image'] != null ? map['image'].toString() : '',
    );
  }

  String toJson() => json.encode(toMap());
}
