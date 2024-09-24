import 'dart:convert';

class UserModel {
  String email;
  String firstName;
  String lastName;
  String fullName;
  String? profileImage;
  String? secretKey;

  UserModel({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    this.profileImage,
    this.secretKey,
  });

  UserModel copyWith({
    String? email,
    String? firstName,
    String? lastName,
    String? fullName,
    String? profileImage,
    String? secretKey,
  }) {
    return UserModel(
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      fullName: fullName ?? this.fullName,
      profileImage: profileImage ?? this.profileImage,
      secretKey: secretKey ?? this.secretKey,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'fullName': fullName,
      'profileImage': profileImage,
      'secretKey': secretKey,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      fullName: map['fullName'] as String,
      profileImage:
          map['profileImage'] != null ? map['profileImage'] as String : '',
      secretKey: map['secretKey'] != null ? map['secretKey'] as String : '',
    );
  }

  String toJson() => jsonEncode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(jsonDecode(source) as Map<String, dynamic>);
}
