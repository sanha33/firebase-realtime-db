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




class DrawingBoard extends StatefulWidget {

  get app => null;

  @override
  _DrawingBoardState createState() => _DrawingBoardState();

}

class _DrawingBoardState extends State<DrawingBoard> {

  final referenceDatabase = FirebaseDatabase.instance;

  final point = 'Point List';
  //final movieController = TextEditingController();

  late DatabaseReference _pointsRef;

  @override
  void initState() {

    final FirebaseDatabase database = FirebaseDatabase(app: widget.app);
    _pointsRef = database.reference().child('Points');

    super.initState();

  }

  Color selectedColor = Colors.black;
  double strokeWidth = 5;
  List<DrawingPoint> drawingPoints = [];
  List<Color> colors = [
    Colors.pink,
    Colors.red,
    Colors.black,
    Colors.yellow,
    Colors.amberAccent,
    Colors.purple,
    Colors.green,
  ];


  final _offsets = <Offset>[];


  @override
  Widget build(BuildContext context) {
    final ref1 = referenceDatabase.reference();

    return Scaffold(
      body: Stack(
        children: [


          GestureDetector(

            onPanStart: (details) {

              setState(() {
                drawingPoints.add(
                  DrawingPoint(
                    details.localPosition,
                    Paint()
                      ..color = selectedColor
                      ..isAntiAlias = true
                      ..strokeWidth = strokeWidth
                      ..strokeCap = StrokeCap.round,
                  ),
                );
                print(details.localPosition);
                ref1
                    .child('Points')
                    .push()
                    .child(point)
                    .set(details.localPosition.dx)
                    .asStream();


              });
              ref1
                  .child('Points')
                  .push()
                  .child(point)
                  .set(details.localPosition.dx)
                  .asStream();
            },
            onPanUpdate: (details) {
              setState(() {
                drawingPoints.add(
                  DrawingPoint(
                    details.localPosition,
                    Paint()
                      ..color = selectedColor
                      ..isAntiAlias = true
                      ..strokeWidth = strokeWidth
                      ..strokeCap = StrokeCap.round,
                  ),

                );
                print(details.localPosition);
                ref1
                    .child('Points')
                    .push()
                    .child(point)
                    .set(details.localPosition.dx)
                    .asStream();

              });
              ref1
                  .child('Points')
                  .push()
                  .child(point)
                  .set(details.localPosition.dx)
                  .asStream();
            },
            onPanEnd: (details) {
              setState(() {
                ref1
                    .child('Points')
                    .push()
                    .child(point)
                    .set(drawingPoints)
                    .asStream();
                drawingPoints = [];

                drawingPoints.add(drawingPoints[-1]);
              });

            },
            child: CustomPaint(
              painter: _DrawingPainter(drawingPoints),
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ),

          Positioned(
            top: 40,
            right: 30,
            child: Row(
              children: [
                Slider(
                  min: 0,
                  max: 40,
                  value: strokeWidth,
                  onChanged: (val) => setState(() => strokeWidth = val),
                ),
                // ElevatedButton.icon(
                //   onPressed: () => setState(() => drawingPoints = []),
                //   icon: Icon(Icons.clear),
                //   label: Text("Clear Board"),
                // ),
                Container(
                    child: new FirebaseAnimatedList(
                        query: _pointsRef,
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
                            title: new Text(snapshot.value['Point List']),
                          );
                        })),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          color: Colors.grey[200],
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              colors.length,
                  (index) => _buildColorChose(colors[index]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColorChose(Color color) {
    bool isSelected = selectedColor == color;
    return GestureDetector(
      onTap: () => setState(() => selectedColor = color),
      child: Container(
        height: isSelected ? 47 : 40,
        width: isSelected ? 47 : 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
        ),
      ),
    );
  }
}




class _DrawingPainter extends CustomPainter {


  final List<DrawingPoint> drawingPoints;

  _DrawingPainter(this.drawingPoints);

  List<Offset> offsetsList = [];

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < drawingPoints.length; i++) {
      if (drawingPoints[i] != null && drawingPoints[i + 1] != null) {
        canvas.drawLine(drawingPoints[i].offset, drawingPoints[i + 1].offset,
            drawingPoints[i].paint);

      } else if (drawingPoints[i] != null && drawingPoints[i + 1] == null) {
        offsetsList.clear();
        offsetsList.add(drawingPoints[i].offset);

        canvas.drawPoints(
            PointMode.points, offsetsList, drawingPoints[i].paint);
      }


    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class DrawingPoint {
  Offset offset;
  Paint paint;

  DrawingPoint(this.offset, this.paint);
}


