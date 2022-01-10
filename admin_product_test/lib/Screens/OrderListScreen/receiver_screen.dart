import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    String uid;

    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance.collection('Cart').snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshotCart) {
          if (!snapshotCart.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            children: snapshotCart.data.documents.map((doc) {
              roomNumber = null;
              uid = null;

              for (var i in doc.data.values) {
                roomNumber = i['Room Number'].toString();
                uid = i['User Id'].toString();

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
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          "Room: " + roomNumber.toString(),
                          style: GoogleFonts.poppins(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        subtitle: SelectableText(
                          uid ?? 'hi',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Column(
                        children: [
                          for (var i in doc.data.values)
                            Container(
                              // width: MediaQuery.of(context).size.width,
                              child: Text(
                                i['Title'] + " x " + i['Quantity'].toString(),
                                style: GoogleFonts.poppins(),
                                textAlign: TextAlign.start,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),

                  // child: Container(
                  //   padding: EdgeInsets.all(30),
                  //   child: Row(
                  //     children: <Widget>[
                  //       Column(children: [
                  //         Container(
                  //           child: SelectableText(
                  //             uid ?? 'hi',
                  //             textAlign: TextAlign.center,
                  //             style: TextStyle(fontWeight: FontWeight.bold),
                  //           ),
                  //         ),
                  //         Text(
                  //           "Room: " + roomNumber.toString(),
                  //           style: GoogleFonts.poppins(
                  //               fontSize: 20, fontWeight: FontWeight.bold),
                  //           textAlign: TextAlign.center,
                  //         ),
                  //       ]),
                  //       SizedBox(
                  //         width: 30,
                  //       ),
                  //       Column(
                  //         children: [
                  //           for (var i in doc.data.values)
                  //             Text(
                  //               i['Title'] + " x " + i['Quantity'].toString(),
                  //               style: GoogleFonts.poppins(),
                  //               textAlign: TextAlign.start,
                  //             ),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
