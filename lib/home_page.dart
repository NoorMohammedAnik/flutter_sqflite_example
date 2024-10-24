import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sqflite_example/add_notes.dart';
import 'package:flutter_sqflite_example/update_notes.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'database/db_helper.dart';
import 'model/note.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //declared variables
  late DatabaseHelper dbHelper;
  List<Note> notes = [];


  @override
  void initState() {
    super.initState();
    //initializing dbHelper
    dbHelper = DatabaseHelper.instance;

    //load notes on startup
    _loadNotes();
  }


  //for loading data from db
  Future _loadNotes() async {
    final data = await dbHelper.queryAllRows();
    setState(() {
      notes = data.map((e) => Note.fromMap(e)).toList();
    });
  }



  //for deleting a note
  Future _deleteNote(int id) async {
    int check= await dbHelper.delete(id);
    if(check>0){
      Fluttertoast.showToast(msg: "Note deleted successfully");
      _loadNotes();
    }
    else
      {
        Fluttertoast.showToast(msg: "Failed to delete note");
      }

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Notes",style: TextStyle(
          color: Colors.white
        ),),
      ),
      body: notes.isEmpty
          ? const Center(child: Text("No notes yet!"))
          : ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                    color: Colors.blue, width: 1),
                borderRadius: BorderRadius.circular(5),
              ),
              onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> UpdateNotes(notes: note)));
              },  // for clickable list item
              title: Text(note.title,style: TextStyle(
                fontWeight: FontWeight.bold
              ),),
              subtitle: Text(note.description),
              leading: const Icon(
                Icons.note_alt_outlined,
                size: 40,

              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete,color: Colors.redAccent,size: 40,),
                onPressed: () {


                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.question,
                    headerAnimationLoop: false,
                    animType: AnimType.bottomSlide,
                    title: 'Delete',
                    desc: 'Want to delete note ?',
                    buttonsTextStyle:
                    const TextStyle(color: Colors.white),
                    showCloseIcon: true,
                    btnCancelOnPress: () {},
                    btnOkText: 'YES',
                    btnCancelText: 'NO',
                    btnOkOnPress: () {

                      _deleteNote(note.id!);
                      Navigator.of(context).pop();

                    },
                  ).show();
                } ,
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        // shape: CircleBorder(
        //   side: BorderSide(color: Colors.blue),
        // ),  //for making circle shape
        backgroundColor: Colors.blue,
        tooltip: "Add Note",
        mini: false,
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>AddNotes()));
        },
        child: const Icon(Icons.add,
        color: Colors.white,),
      ),
    );
  }
}