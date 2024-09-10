import 'dart:convert';

class UserModel {
  String id;
  String email;
  String firstName;
  String lastName;
  String fullName;
  String? profileImage;

  UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    this.profileImage,
  });

  UserModel copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? fullName,
    String? profileImage,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      fullName: fullName ?? this.fullName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'fullName': fullName,
      'profileImage': profileImage,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      email: map['email'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      fullName: map['fullName'] as String,
      profileImage:
          map['profileImage'] != null ? map['profileImage'] as String : null,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(jsonDecode(source) as Map<String, dynamic>);

}
