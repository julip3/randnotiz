import 'package:flutter/foundation.dart';
import 'package:randnotiz/models/Note.dart';
import 'package:randnotiz/models/NoteCategory.dart';

abstract class NotesEvent {}

class DeleteNoteEvent extends NotesEvent {
  Note note;
  NoteCategory category;

  DeleteNoteEvent(this.note, this.category);
}

class CreateNoteEvent extends NotesEvent {
  String title;
  String text;
  int doneTilDate;
  NoteCategory category;

  CreateNoteEvent(
    this.title,
    this.text,
    this.doneTilDate,
    this.category,
  );
}

class EditNoteEvent extends NotesEvent {
  String title;
  String text;
  int doneTilDate;
  Note note;

  EditNoteEvent(
    this.title,
    this.text,
    this.doneTilDate,
    this.note,
  );
}

class ChangeNoteCategoryEvent extends NotesEvent {
  Note note;
  NoteCategory oldCategory;
  NoteCategory newCategory;

  ChangeNoteCategoryEvent(
    this.note,
    this.oldCategory,
    this.newCategory,
  );
}

class CreateCategoryEvent extends NotesEvent {
  String title;

  CreateCategoryEvent(this.title);
}

class DeleteCategoryEvent extends NotesEvent {
  NoteCategory category;

  DeleteCategoryEvent(this.category);
}

class EditCategoryEvent extends NotesEvent {
  String title;
  NoteCategory category;

  EditCategoryEvent(this.title, this.category);
}
