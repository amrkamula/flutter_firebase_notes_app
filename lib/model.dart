import 'package:firebase_database/firebase_database.dart';

class Note{
  String? id;
  String? title;
  String? description;

  Note({required this.id,required this.title,required this.description});

  factory Note.fromSnapshot(DataSnapshot snapshot){
    return Note(id: snapshot.key,
        title: snapshot.value['title'],
        description: snapshot.value['description']);
  }
}