import 'package:flutter/foundation.dart';

class Note {
  String title;
  String text;
  int doneTilDate;

  Note({
    @required this.title,
    @required this.text,
    @required this.doneTilDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'text': text,
      'doneTilDate': doneTilDate
    };
  }
}
