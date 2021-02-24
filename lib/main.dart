import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ref = FirebaseFirestore.instance.collection("Contact Details");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text(
              "Contact Details",
              style: (TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )),
            )),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      " Prime Ministers ",
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                    Container(
                        height: 100,
                        width: 600,
                        child: Image.network(
                          "https://twiplomacy.com/wp-content/uploads/2020/04/World-Leaders-on-Facebook-2020-Cover-1024x576.jpg",
                          fit: BoxFit.fill,
                        )),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: StreamBuilder(
                          stream: ref.snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              return GridView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  reverse: true,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 1),
                                  // scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data.docs.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 1200,
                                        width: 600,
                                        child: Column(
                                          children: [
                                            Text(
                                              snapshot.data.docs[index]
                                                  .data()["Person_Name"],
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 25),
                                            ),
                                            Text(snapshot.data.docs[index]
                                                .data()["Email_id"]),
                                            Text(snapshot.data.docs[index]
                                                .data()["Mobile_No"]
                                                .toString()),
                                            Container(
                                                height: 250,
                                                width: 300,
                                                child: Image.network(
                                                    snapshot.data.docs[index]
                                                        .data()["Image"],
                                                    fit: BoxFit.fill)),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            } else {
                              return CircularProgressIndicator();
                            }
                          }),
                    )
                  ],
                ),
              ),
            );
  }
}
