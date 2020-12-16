import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:randnotiz/bloc/notes_bloc.dart';
import 'package:randnotiz/bloc/notes_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

bool a = true;
CollectionReference users = FirebaseFirestore.instance.collection('users');

class _NotesScreenState extends State<NotesScreen> {
  final _bloc = NotesBloc();
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();

  //TODO delete after testing
  void test() {
    _bloc.notesEventSink.add(CreateCategoryEvent("Category Name"));
    Future.delayed(const Duration(milliseconds: 500), () {

      _bloc.notesEventSink.add(CreateNoteEvent("nice title", "nice text",
          DateTime.now().millisecondsSinceEpoch, _bloc.categories[0]));
      setState(() {

      });
    });
  }

  BoxDecoration _decoInTimeRelation(int index, index2) {
    //TODO delete after using the BoxDecoration where its needed
    return BoxDecoration(
        border: Border.all(
      width: 2,
      color: Colors.red,
    ));
  }

  @override
  Widget build(BuildContext context) {
    TextField title = TextField(
      decoration: InputDecoration(labelText: "Search"),
      controller: searchController,
      enabled: isSearching,
      autofocus: true,
      //TODO search notes on submited and on changed
      //onSubmitted: ,
      //onChanged: (_),
    );
    AppBar appbar = AppBar(
      actions: <Widget>[
        //TODO add on Pressed for both icon buttons
        IconButton(
          icon: Icon(Icons.settings),
          //TODO on pressed open settings screen
          //onPressed: (_),
        ),
        IconButton(
          icon: (isSearching) ? Icon(Icons.clear) : Icon(Icons.search),
          onPressed: () {
            isSearching = !isSearching;
            //TODO put issearched in block
          },
        ),
      ],
      title: (isSearching) ? title : Text("Notes"),
    );

    return Scaffold(
      appBar: appbar,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: _bloc.categories.length,
          itemBuilder: (BuildContext categoriesCtx, int categoriesIndex) {
            return Container(
              margin: new EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: new BorderRadius.all(
                  const Radius.circular(8.0),
                ),
                border: Border.all(),
                color: Colors.black54,
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: IconButton(
                          icon: _bloc.categories[categoriesIndex].isVisibleTemp
                              ? Icon(Icons.menu)
                              : Icon(Icons.more_vert),
                          onPressed: () {
                            _bloc.categories[categoriesIndex]
                                .changeVisibility();
                            setState(() {

                            });
                          },
                        ),
                      ),
                      Container(
                        child: Text(
                          _bloc.categories[categoriesIndex].title,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.note_add),
                        onPressed: () {
                          //TODO Create note creation form
                        },
                      ),
                    ],
                  ),
                  Visibility(
                    visible: _bloc.categories[categoriesIndex].isVisibleTemp,
                    child: Column(
                      children: <Widget>[
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _bloc.categories[categoriesIndex]
                              .notesFromCategory.length,
                          itemBuilder:
                              (notesFromCategoryCtx, notesFromCategoryIndex) {
                            return Card(
                              margin: EdgeInsets.symmetric(
                                vertical: 2,
                                horizontal: 2,
                              ),
                              elevation: 7,
                              child: Container(
                                decoration: _decoInTimeRelation(
                                    categoriesIndex, notesFromCategoryIndex),
                                child: ListTile(
                                  leading: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        new DateFormat("dd/MM/yy\nHH:mm")
                                            .format(
                                          new DateTime
                                                  .fromMillisecondsSinceEpoch(
                                              _bloc
                                                  .categories[categoriesIndex]
                                                  .notesFromCategory[
                                                      notesFromCategoryIndex]
                                                  .doneTilDate),
                                        ),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          //TODO edit note
                                        },
                                        child: Text(
                                          "edit",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                  title: Text(
                                    _bloc
                                        .categories[categoriesIndex]
                                        .notesFromCategory[
                                            notesFromCategoryIndex]
                                        .title,
                                  ),
                                  subtitle: Text(
                                    _bloc
                                        .categories[categoriesIndex]
                                        .notesFromCategory[
                                            notesFromCategoryIndex]
                                        .text,
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete_forever),
                                    color: Theme.of(context).errorColor,
                                    onPressed: () {
                                      //TODO delete note
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        Builder(
                          builder: (context) => ListTile(
                            leading: GestureDetector(
                              child: Icon(Icons.edit),
                              onTap: () {
                                //TODO edit note category
                              },
                            ),
                            trailing: GestureDetector(
                              child: Icon(Icons.delete),
                              onTap: () {
                                if (_bloc.categories[categoriesIndex]
                                        .notesFromCategory.length >
                                    0) {
                                  //TODO get flushbar
                                  /*Flushbar(
                                    title: "Cant delete category",
                                    message:
                                    "Categories must be empty, to be deleted",
                                    duration: Duration(seconds: 2),
                                  )..show(context);*/
                                } else {
                                  //TODO delete category
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          test();
        },
        tooltip: 'Add Note',
        child: Icon(Icons.library_add),
      ),
    );
  }
}
