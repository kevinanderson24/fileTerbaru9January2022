import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebutler/Model/product_model.dart';
import 'package:ebutler/Screens/ProductScreen/addproduct_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({ Key key }) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  CollectionReference products = Firestore.instance.collection("product");
  TextEditingController _nameProductController = TextEditingController();
  TextEditingController _priceProductController = TextEditingController();
  TextEditingController _descriptionProductController = TextEditingController();
  File image;
  final imagePicker = ImagePicker();
  String fileName;
  String downloadURL;
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder(
                    stream: Firestore.instance.collection('product').snapshots(),
                    builder: (context, snapshot) {
                      if(!snapshot.hasData){
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return DataTable(
                        headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey),
                        showBottomBorder: true,
                        dataRowHeight: 80,
                        columns: [
                          DataColumn(label: Text('Id', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Price', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Description', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Url', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('')), //delete
                        ],
                        rows: _buildList(context, snapshot.data.documents),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      //--------------------- Button (+) ----------------------//
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          //menuju ke page "Add Product"
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddProduct(),));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  List<DataRow> _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return snapshot.map((data) => _buildListItem(context, data)).toList();
  }

  DataRow _buildListItem(BuildContext context, DocumentSnapshot data) {
    return DataRow(cells: [
      DataCell(
        Text(data['id'].toString())
      ),

      DataCell(
        Text(
          data['name'].toString()
        ), 
        showEditIcon: true,
        onTap: () {
          showDialog(
            context: context, 
            builder: (context) {
              return AlertDialog(
                title: Text('Edit Name'),
                content: Container(
                  height: 50,
                  width: 70,
                  child: TextField(
                    controller: _nameProductController,
                    decoration: InputDecoration(hintText: 'Name', border: OutlineInputBorder()),
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      products.document(data.documentID).updateData({
                        'name': _nameProductController.text,
                      }).whenComplete(() => Navigator.pop(context));
                    }, 
                    child: Text('Submit'),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    }, 
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                    ),
                    child: Text('Cancel'),
                  )
                ],
              );
            },);
        },
      ),

      DataCell(
        Text(
          data['price'].toString()
        ), 
        showEditIcon: true,
        onTap: () {
          showDialog(
            context: context, 
            builder: (context) {
              return AlertDialog(
                title: Text('Edit Price'),
                content: Container(
                  height: 50,
                  width: 70,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    controller: _priceProductController,
                    decoration: InputDecoration(hintText: 'Price', border: OutlineInputBorder()),
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      products.document(data.documentID).updateData({
                        'name': int.tryParse(_priceProductController.text),
                      }).whenComplete(() => Navigator.pop(context));
                    }, 
                    child: Text('Submit'),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    }, 
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                    ),
                    child: Text('Cancel'),
                  )
                ],
              );
            },
          );
        },
      ),

      DataCell(
        Text(
          data['description'].toString()
        ), 
        showEditIcon: true,
        onTap: () {
          showDialog(
            context: context, 
            builder: (context) {
              return AlertDialog(
                title: Text('Edit Description'),
                content: Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width - 600,
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    controller: _descriptionProductController,
                    minLines: 5,
                    maxLines: 7,
                    decoration: InputDecoration(hintText: 'Description', border: OutlineInputBorder()),
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      products.document(data.documentID).updateData({
                        'name': _descriptionProductController.text,
                      }).whenComplete(() => Navigator.pop(context));
                    }, 
                    child: Text('Submit'),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    }, 
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                    ),
                    child: Text('Cancel'),
                  )
                ],
              );
            },
          );
        },
      ),

      DataCell(
        Container(
          width: 410,
          child: Text(data['url'].toString())
        ), 
      showEditIcon: true,
      onTap: () {
        showDialog(
          context: context, 
          builder: (context) {
            return AlertDialog(
              title: Text("Edit Image"),
              content: Container(
                height: 100,
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                width: MediaQuery.of(context).size.width - 800,
                alignment: Alignment.topCenter,
                child: Row(
                  children: [
                    
                    // (image != null)
                    // ? Image.file(
                    //   image,
                    //   width: 200,
                    //   height: 180,
                    //   fit: BoxFit.cover,
                    // )
                    // : Container(
                    //   width: 200,
                    //   height: 180,
                    //   alignment: Alignment.center,
                    //   decoration: BoxDecoration(
                    //     shape: BoxShape.rectangle,
                    //     border: Border.all(color: Colors.black),
                    //     borderRadius: BorderRadius.circular(10),
                    //   ),
                    //   child: Text("No image Selected",
                    //     style: TextStyle(
                    //       fontSize: 12,)),
                    // ),

                    SizedBox(width: 20,),

                    Container(
                      margin: EdgeInsets.only(left: 100),
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        width: 200,
                        height: 300,
                        child: ElevatedButton.icon(
                          label: Text("Select Image", 
                            textAlign: TextAlign.center, 
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),),
                          icon: Icon(Icons.add_photo_alternate),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.greenAccent, // background color
                            onPrimary: Colors.white, // foreground color
                            shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                            alignment: Alignment.centerLeft,
                          ),
                          onPressed: () {
                            pickImage();
                            Navigator.pop(context);
                            uploadImageToFirebaseStorage().whenComplete(() {
                              products.document(data.documentID).updateData({
                                'url': downloadURL,
                              }).whenComplete(() => Navigator.pop(context));
                            });
                          },    
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  }, 
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  child: Text('Cancel'),
                )
              ],
            );
          },
        );
      },
      ),


     
      //--------------------- "DELETE BUTTON" --------------------------------//
      DataCell(Container(
        height: 35,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(5),
        ),
        child: IconButton(
          highlightColor: Colors.orange[100],
          splashColor: Colors.green[100],
          onPressed: () {
            products.document(data.documentID).delete();
          }, 
          icon: Icon(Icons.delete, color: Colors.white, size: 20.0,),
        ),
      )),
      //------------------------end of "DELETE BUTTON"------------------------//
    ]);
  }
  
  //image picker
  Future pickImage() async {
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);
  
    setState(() {
      if (pick != null) {
        image = File(pick.path);
      }
    });
  }

  Future uploadImageToFirebaseStorage() async {
    fileName = basename(image.path);
    StorageReference ref =
        FirebaseStorage.instance.ref().child('product/$fileName');
    StorageUploadTask uploadTask = ref.putFile(image);
    StorageTaskSnapshot snapshot = await uploadTask.onComplete;
    downloadURL = await snapshot.ref.getDownloadURL();
    // print(downloadURL); //url will be show on terminal
  }
}