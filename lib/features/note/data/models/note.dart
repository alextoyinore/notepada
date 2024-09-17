import 'dart:convert';

class NoteModel {
  String id;
  String userID;
  String title;
  String? formattedText;
  String? color;
  String? plainText;
  String date;
  String dateModified;
  bool? isSecret;

  NoteModel({
    required this.id,
    required this.userID,
    required this.date,
    required this.title,
    required this.dateModified,
    this.color,
    this.formattedText,
    this.plainText,
    this.isSecret,
  });

  NoteModel copyWith({
    String? id,
    String? userID,
    String? formattedText,
    String? color,
    String? plainText,
    bool? isSecret,
    String? date,
    String? dateModified,
    String? title,
  }) {
    return NoteModel(
      id: id ?? this.id,
      userID: userID ?? this.userID,
      title: title ?? this.title,
      formattedText: formattedText ?? this.formattedText,
      color: color ?? this.color,
      plainText: plainText ?? this.plainText,
      isSecret: isSecret ?? this.isSecret,
      date: date ?? this.date,
      dateModified: dateModified ?? this.dateModified,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userID': userID,
      'title': title,
      'formattedText': formattedText,
      'color': color,
      'isSecret': isSecret,
      'plainText': plainText,
      'date': date,
      'dateModified': dateModified,
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'] as String,
      userID: map['userID'] as String,
      title: map['title'] as String,
      formattedText:
          map['formattedText'] != null ? map['formattedText'] as String : '',
      color: map['color'] != null ? map['color'] as String : '',
      isSecret: map['isSecret'] != null ? map['isSecret'] as bool : false,
      plainText: map['plainText'] != null ? map['plainText'] as String : '',
      date: map['date'] as String,
      dateModified: map['dateModified'] as String,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory NoteModel.fromJson(String source) =>
      NoteModel.fromMap(jsonDecode(source) as Map<String, dynamic>);
}
