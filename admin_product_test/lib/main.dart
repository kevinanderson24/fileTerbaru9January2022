import 'package:ebutler/Screens/OrderListScreen/receiver_screen.dart';
import 'package:ebutler/Screens/product_screen.dart';
import 'package:ebutler/Screens/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue[900],
            title: Text("Binus Hotel", style: TextStyle(fontWeight: FontWeight.bold),),
            actions: <Widget> [
              IconButton(
                icon: Icon(Icons.search, color: Colors.white,),
              ),
            ],
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.list), text: 'ORDER'),
                Tab(icon: Icon(Icons.list), text: 'PRODUCT',),
                Tab(icon: Icon(Icons.people), text: 'USER',),
              ],
              unselectedLabelColor: Colors.black,
            ),
          ),
          body: TabBarView(
            children: [
              Receiver(),
              ProductScreen(),
              UserScreen(),
            ],
          ),
        ),
      ),
    );
  }
}