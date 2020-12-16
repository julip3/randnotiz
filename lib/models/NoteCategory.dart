import 'package:flutter/foundation.dart';

import 'Note.dart';

class NoteCategory {
  String title;
  //TODO rename and make private
  bool isVisibleTemp;
  List<Note> notesFromCategory = List<Note>();

  NoteCategory(
      {@required this.title,
      @required this.isVisibleTemp,
      @required this.notesFromCategory});

  String get noteCategoryTitle {
    return this.title;
  }

  bool get isVisible {
    return this.isVisibleTemp;
  }

  void changeVisibility() {
    this.isVisibleTemp = !this.isVisibleTemp;
  }

  void addNote(Note note) {
    print("NOTE WIRD HINZUGEFÜGT");
    notesFromCategory.add(note);
  }


  Map<String, dynamic> toMap() {
    return {
      'title': this.title,
      'isVisible': this.isVisibleTemp,
    };
  }
}
