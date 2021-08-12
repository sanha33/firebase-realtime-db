import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:ui';

class CustomData extends StatefulWidget {
  get app => null;

  // CustomData({required this.app});
  //
  // final FirebaseApp app;

  @override
  _CustomDataState createState() => _CustomDataState();
}

class _CustomDataState extends State<CustomData> {


  final referenceDatabase = FirebaseDatabase.instance;

  final movieName = 'MovieTitle';
  final movieController = TextEditingController();

  late DatabaseReference _moviesRef;

  @override
  void initState() {

    final FirebaseDatabase database = FirebaseDatabase(app: widget.app);
    _moviesRef = database.reference().child('Movies');

    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    final ref = referenceDatabase.reference();
    return Scaffold(
      appBar: AppBar(
        title: Text('Movies That I love'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
                child: Container(
              color: Colors.green,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Text(
                    movieName,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: movieController,
                    textAlign: TextAlign.center,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ref
                          .child('Movies')
                          .push()
                          .child(movieName)
                          .set(movieController.text)
                          .asStream();
                      movieController.clear();
                    },
                    child: Text('Save movie'),
                  ),
                  Flexible(
                      child: new FirebaseAnimatedList(
                          query: _moviesRef,
                          itemBuilder: (BuildContext context,
                              DataSnapshot snapshot,
                              Animation<double> animation,
                              int index) {
                            return new ListTile(
                              // trailing: IconButton(
                              //   icon: Icon(Icons.delete),
                              //   onPressed: (){}
                              //   // =>
                              //   //     _moviesRef.child(snapshot.key).remove(),
                              // ),
                              title: new Text(snapshot.value['MovieTitle']),
                            );
                          }))
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}




