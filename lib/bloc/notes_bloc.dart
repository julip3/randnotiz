import 'dart:async';
import 'package:randnotiz/models/Note.dart';
import 'package:randnotiz/models/NoteCategory.dart';

import 'notes_event.dart';

class NotesBloc {
  ///////////////////////////////BLOC STUFF\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
  List<NoteCategory> categories = [];

  final _notesStateController = StreamController<List<NoteCategory>>();

  StreamSink<List<NoteCategory>> get _inNotes => _notesStateController.sink;

  // For state, exposing only a stream which outputs data
  // basically the output
  Stream<List<NoteCategory>> get notes => _notesStateController.stream;

  final _notesEventController = StreamController<NotesEvent>();

  //For events, exposing only a sink which is an input
  Sink<NotesEvent> get notesEventSink => _notesEventController.sink;

  NotesBloc() {
    //Whenever there is a new event, we want to map it to a new state
    _notesEventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(NotesEvent event) {
    if (event is CreateNoteEvent) {
      _createNote(event.title, event.text, event.doneTilDate, event.category);
    } else if (event is EditNoteEvent) {
      _editNote(event.title, event.text, event.doneTilDate, event.note);
    } else if (event is DeleteNoteEvent) {
      _deleteNote(event.note, event.category);
    } else if (event is CreateCategoryEvent) {
      _createCategory(event.title);
    } else if (event is EditCategoryEvent) {
      _editCategory(event.title, event.category);
    } else if (event is DeleteCategoryEvent) {
      _deleteCategory(event.category);
    } else if (event is ChangeNoteCategoryEvent) {
      _changeNoteCategory(event.note, event.oldCategory, event.newCategory);
    }
  }

  void dispose() {
    _notesEventController.close();
    _notesStateController.close();
  }

///////////////////////////END OF BLOC STUFF\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
  void _createNote(
      String title, String text, int doneTilDate, NoteCategory category) {
    Note note = Note(
      title: title,
      text: text,
      doneTilDate: doneTilDate,
    );
    category.addNote(note);
  }

  void _editNote(String title, String text, int doneTilDate, Note note) {
    note.title = title;
    note.text = text;
    note. doneTilDate = doneTilDate;
  }

  void _deleteNote(Note note, NoteCategory category) {
    //TODO cases where note is not found etc
    category.notesFromCategory.remove(note);
  }

  void _createCategory(String title) {
    NoteCategory category = NoteCategory(
      title: title,
      isVisibleTemp: true,
      notesFromCategory: List<Note>(),
    );
    categories.add(category);
  }

  void _editCategory(String title, NoteCategory category) {
    category.title = title;
  }

  void _deleteCategory(NoteCategory category) {
    if(category.notesFromCategory.length == 0) {
      categories.remove(category);
    }else {
      //TODO display that category is not empty
    }
  }

  void _changeNoteCategory(Note note, NoteCategory oldCategory, NoteCategory newCategory) {
    oldCategory.notesFromCategory.remove(note);
    newCategory.notesFromCategory.add(note);
  }

  bool _validateNote() {
    //TODO validating title, text, and doneTilDate from a note
  }
}
