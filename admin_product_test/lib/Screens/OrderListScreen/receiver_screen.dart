import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Receiver extends StatefulWidget {
  const Receiver({Key key}) : super(key: key);

  @override
  State<Receiver> createState() => _ReceiverState();
}

class _ReceiverState extends State<Receiver> {

  @override
  Widget build(BuildContext context) {
    String roomNumber;
    bool visibility = true;

    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance.collection('Cart').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            children: snapshot.data.documents.map((doc) {
              roomNumber = null;
              for (var i in doc.data.values) {
                roomNumber = i['Room Number'].toString();
                break;
              }
              if (roomNumber == null) {
                visibility = false;
              } else {
                visibility = true;
              }
              return Visibility(
                visible: visibility,
                child: Card(
                  child: Container(
                    padding: EdgeInsets.all(30),
                    child: Row(
                      children: <Widget>[
                        Column(children: [
                          Text(
                            "Room: " + roomNumber.toString(),
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ]),
                        SizedBox(
                          width: 30,
                        ),
                        Column(
                          children: [
                            for (var i in doc.data.values)
                              Text(
                                i['Title'] + " x " + i['Quantity'].toString(),
                                textAlign: TextAlign.start,
                              )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
