import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app_fire/third_screem.dart';
import 'model.dart';

class SecondScreen extends StatefulWidget {
  final String? email;

  SecondScreen({required this.email});
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {

  DatabaseReference? root;
  List<Note>? notes;
  StreamSubscription? addStream;
  StreamSubscription? updateStream;
  StreamSubscription? deleteStream;

  void initialize() async {
    await Firebase.initializeApp();
  }

  @override
  void initState() {
    root  = FirebaseDatabase.instance.reference().child('notes');
    notes = [];
    addStream = root!.onChildAdded.listen((event) {
      setState(() {
        notes!.add(Note.fromSnapshot(event.snapshot));
      });
    });

    updateStream = root!.onChildChanged.listen((event) {
      Note oldValue = notes!.singleWhere((element) => element.id == event.snapshot.key);
      setState(() {
        notes![notes!.indexOf(oldValue)] =  Note.fromSnapshot(event.snapshot);
      });
    });

    deleteStream = root!.onChildRemoved.listen((event) {
      Note oldValue = notes!.singleWhere((element) => element.id == event.snapshot.key);
      setState(() {
        notes!.remove(oldValue);
      });
    });

    initialize();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    addStream!.cancel();
    updateStream!.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add,color: Colors.white,),
        onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ThirdScreen(note: Note(id: null,title: '',description: ''))));
        },
      ),
      appBar: AppBar(
        title: Text('Notes',style: TextStyle(fontSize: 25.0),),
        actions: [
          TextButton(
              child: Text(
                'Sign out',
                style: TextStyle(color: Colors.white, fontSize: 18.0),
              ),
              onPressed: () async {
                try {
                  FirebaseAuth _auth = FirebaseAuth.instance;
                  await _auth.signOut();
                  Navigator.of(context).pop();
                } catch (e) {
                  print(e.toString());
                }
              }),
          SizedBox(width: 20.0,),
        ],
      ),
      body: ListView.builder(
          itemCount: notes!.length,
          itemBuilder: (context,index){
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ThirdScreen(note: notes![index])));
            },
            child: Card(
              child: ListTile(
                trailing: IconButton(
                  icon: Icon(Icons.delete,color: Colors.red,),
                  onPressed: () async{
                    await root!.child(notes![index].id!).remove();
                  },
                ),
                title: Text('${notes![index].title}',style: TextStyle(fontSize: 20.0),),
                subtitle: Text('${notes![index].description}',style: TextStyle(fontSize: 16.0),),
              ),
            ),
          ),
        );
      })
    );
  }
}
