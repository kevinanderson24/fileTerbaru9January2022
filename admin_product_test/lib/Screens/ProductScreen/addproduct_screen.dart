import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebutler/Model/product_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';


class AddProduct extends StatefulWidget {
  const AddProduct({key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  CollectionReference collectionReference =
      Firestore.instance.collection('product');
  final _formkey = GlobalKey<FormState>(); //formkey
  final TextEditingController nameController =
      new TextEditingController(); //controller
  final TextEditingController priceController =
      new TextEditingController(); //controller
  final TextEditingController descriptionController =
      new TextEditingController(); //controller
  final TextEditingController idController =
      new TextEditingController(); //controller
  File image;
  final imagePicker = ImagePicker();
  String fileName;
  String downloadURL;

  //image picker
  Future pickImage() async {
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pick != null) {
        image = File(pick.path);
      }
    });
  }

  //uploading the image, then getting the download url and then
  //adding that download url to our cloud Firestore
  Future uploadImageToFirebaseStorage() async {
    fileName = basename(image.path);
    StorageReference ref =
        FirebaseStorage.instance.ref().child('product/$fileName');
    StorageUploadTask uploadTask = ref.putFile(image);
    StorageTaskSnapshot snapshot = await uploadTask.onComplete;
    downloadURL = await snapshot.ref.getDownloadURL();
    postDetailsToFirestore();
    // print(downloadURL); //url will be show on terminal
  }

  //send details (productname, productprice, url) to firestore
  void postDetailsToFirestore() async {
    Firestore firebaseFirestore = Firestore.instance;
    ProductModel productModel = ProductModel();

    //writing all the values
    productModel.name = nameController.text;
    productModel.id = idController.text;
    productModel.price = int.tryParse(priceController.text);
    productModel.description = descriptionController.text;
    productModel.url = downloadURL;

    await collectionReference
        .document(idController.text)
        .setData(productModel.toMap());

    Fluttertoast.showToast(msg: "Product added successfully!");
  }

  @override
  Widget build(BuildContext context) {
    //idproduk field
    final idProductField = TextFormField(
      autofocus: false,
      controller: idController,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        hintText: "Id",
        contentPadding: EdgeInsets.fromLTRB(20, 5, 20, 5),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return ("Id is required");
        }
        return null;
      },
      onSaved: (newValue) {
        idController.text = newValue;
      },
    );

    //name produk field
    final nameProductField = TextFormField(
      autofocus: false,
      controller: nameController,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        hintText: "Name",
        contentPadding: EdgeInsets.fromLTRB(20, 5, 20, 5),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return ("Name is required");
        }
        return null;
      },
      onSaved: (newValue) {
        nameController.text = newValue;
      },
    );

    //price produk field
    final priceProductField = TextFormField(
      autofocus: false,
      controller: priceController,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        hintText: "Price",
        contentPadding: EdgeInsets.fromLTRB(20, 5, 20, 5),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (value) {
        // final isNumberOnly = int.tryParse(value);
        if (value.isEmpty) {
          return ("Price is required");
        }
        return null;
      },
      onSaved: (newValue) {
        priceController.text = newValue;
      },
    );

    //description product field
    final descriptionProductField = TextFormField(
      autofocus: false,
      controller: descriptionController,
      keyboardType: TextInputType.multiline,
      minLines: 3,
      maxLines: 7,
      textInputAction: TextInputAction.next,
      autocorrect: false,
      decoration: InputDecoration(
        hintText: "Description",
        contentPadding: EdgeInsets.fromLTRB(20, 5, 20, 5),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return ("Description is required");
        }
        return null;
      },
      onSaved: (newValue) {
        descriptionController.text = newValue;
      },
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text("Add Product", style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Container(
                width: MediaQuery.of(context).size.width - 300,
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 20),
                      SizedBox(height: 30),
                      idProductField,
                      SizedBox(height: 20),
                      nameProductField,
                      SizedBox(height: 20),
                      priceProductField,
                      SizedBox(height: 20),
                      descriptionProductField,
                      SizedBox(height: 20),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            (image != null)
                                ? Image.file(
                                    image,
                                    width: 200,
                                    height: 180,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    width: 200,
                                    height: 180,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text("No image Selected",
                                        style: TextStyle(
                                            fontSize: 12,)),
                                  ),
                            SizedBox(
                              width: 20,
                            ),
                            SizedBox(
                              width: 170,
                              child: ElevatedButton.icon(
                                label: Text("Select image",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                icon: Icon(Icons.add_photo_alternate),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.greenAccent, // background color
                                  onPrimary: Colors.white, // foreground color
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  alignment: Alignment.centerLeft,
                                ),
                                onPressed: () async {
                                  pickImage();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Material(
                        elevation: 30,
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue[900],
                        child: MaterialButton(
                          padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
                          minWidth: MediaQuery.of(context).size.width,
                          onPressed: () {
                            if (_formkey.currentState.validate() == true &&
                                image != null) {
                              uploadImageToFirebaseStorage().whenComplete(() {
                                setState(() {
                                  image = null;
                                });
                                idController.text = '';
                                nameController.text = '';
                                priceController.text = '';
                                descriptionController.text = '';
                              });
                              // .whenComplete(() => setState(() {
                              //           image = null;
                              //         }))
                              //     .whenComplete(() {
                              //   idController.text = '';
                              //   nameController.text = '';
                              //   priceController.text = '';
                              //   descriptionController.text = '';
                              // });
                              // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => AddProduct()), (route) => false);
                            } else {
                              Fluttertoast.showToast(
                                  msg:
                                      "Id, Name, Price, and Description cannot be empty, image must be selected",
                                  textColor: Colors.red);
                            }
                          },
                          child: Text(
                            "Submit",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold, color: Colors.white)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),       
              ),
            ),
          ),
        ),
      ),
    );
  }
  
}
