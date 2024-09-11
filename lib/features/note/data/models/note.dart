import 'dart:convert';

class NoteModel {
  String id;
  String userID;
  String title;
  String? text;
  String? audio;
  String? image;
  String date;

  NoteModel({
    required this.id,
    required this.userID,
    required this.date,
    required this.title,
    this.text,
    this.audio,
    this.image,
  });

  NoteModel copyWith({
    String? id,
    String? userID,
    String? text,
    String? audio,
    String? image,
    String? date,
    String? title,
  }) {
    return NoteModel(
      id: id ?? this.id,
      userID: userID ?? this.userID,
      title: title ?? this.title,
      text: text ?? this.text,
      audio: audio ?? this.audio,
      image: image ?? this.image,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userID': userID,
      'title': title,
      'text': text,
      'audio': audio,
      'image': image,
      'date': date,
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'] as String,
      userID: map['userID'] as String,
      title: map['title'] as String,
      text: map['text'] != null ? map['text'] as String : '',
      audio: map['audio'] != null ? map['audio'] as String : '',
      image: map['image'] != null ? map['image'] as String : '',
      date: map['date'] as String,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory NoteModel.fromJson(String source) =>
      NoteModel.fromMap(jsonDecode(source) as Map<String, dynamic>);
}
