import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'model.dart';

class ThirdScreen extends StatefulWidget {
  Note note;

  ThirdScreen({required this.note});

  @override
  _ThirdScreenState createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  DatabaseReference? root;
  TextEditingController? _titleController;
  TextEditingController? _descriptionController;
  GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void initState() {
    root  = FirebaseDatabase.instance.reference().child('notes');
    _titleController = TextEditingController(text: widget.note.title);
    _descriptionController = TextEditingController(text: widget.note.description);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          (widget.note.id == null)?'Add Note':'Update Note',),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _key,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0,horizontal: 30.0),
                    child: TextFormField(
                      validator: (val){
                        if(val ==null||val.isEmpty){
                          return 'Please, enter a title';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'title'
                      ),
                      controller: _titleController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 30.0),
                    child: TextFormField(
                      validator: (val){
                        if(val ==null||val.isEmpty){
                          return 'Please, enter a description';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText: 'description'
                      ),
                      controller: _descriptionController,
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child:  Container(
                padding:
                const EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.blue,
                ),
                child:  TextButton(
                  child: Text(
                    (widget.note.id == null)?'Add':'Update',
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                  onPressed: () async {
                    if (_key.currentState!.validate()) {
                     if(widget.note.id == null){
                       try {
                         await root!.push().set({
                           'title':_titleController!.text,
                           'description':_descriptionController!.text
                         }).then((value){
                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Note has been added successfully'
                             ,style: TextStyle(color: Colors.white,fontSize: 20.0),),
                             backgroundColor: Colors.blue,
                             duration: Duration(seconds: 3),
                           ));
                           Navigator.of(context).pop();
                         });

                       } catch (e) {
                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${e.toString()}'
                           ,style: TextStyle(color: Colors.white,fontSize: 20.0),),
                           backgroundColor: Colors.blue,
                           duration: Duration(seconds: 3),
                         ));
                       }
                       _titleController!.clear();
                       _descriptionController!.clear();
                     }
                     else{
                       try {
                         await root!.child(widget.note.id!).set({
                           'title':_titleController!.text,
                           'description':_descriptionController!.text
                         }).then((value){
                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Note has been updated successfully'
                             ,style: TextStyle(color: Colors.white,fontSize: 20.0),),
                             backgroundColor: Colors.blue,
                             duration: Duration(seconds: 3),
                           ));
                           Navigator.of(context).pop();
                         });

                       } catch (e) {
                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${e.toString()}'
                           ,style: TextStyle(color: Colors.white,fontSize: 20.0),),
                           backgroundColor: Colors.blue,
                           duration: Duration(seconds: 3),
                         ));
                       }
                       _titleController!.clear();
                       _descriptionController!.clear();
                     }
                    }
                  },
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
