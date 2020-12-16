import 'package:firebase_auth/firebase_auth.dart';
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
User user = FirebaseAuth.instance.currentUser;
String uid = user.uid;
CollectionReference notes = FirebaseFirestore.instance
    .collection("users")
    .doc(user.uid)
    .collection("noteCategory")
    .doc("default Category")
    .collection("notes");

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
      setState(() {});
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

    print("penis");
    return Scaffold(
      appBar: appbar,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: StreamBuilder<QuerySnapshot>(
          stream: notes.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            print("\n SIZE: " + snapshot.data.size.toString() + " \n");

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            return new ListView(
              children:
                  snapshot.data.documents.map((DocumentSnapshot document) {
                return new ListTile(
                  title: new Text(document.data()["title"]),
                  subtitle: new Text(document.data()["text"]),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
