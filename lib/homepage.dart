import 'dart:async';
import 'package:face_net_authentication/professor/professorDash.dart';
import 'package:flutter/material.dart';
import 'package:face_net_authentication/components/appbar.dart';
import 'package:flutter/services.dart';
import 'package:face_net_authentication/pages/home.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var data;
  var androidID;
  var _scaffoldContext, context;
  static const platform = const MethodChannel('attendance.student');

  TextStyle btnLable = new TextStyle(
      color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w900);

  openProfessorLoginpage() async {
    Navigator.of(context).push(new MaterialPageRoute(builder: (_) => new ProfessorDashboard()));
  }

  openStudentLoginPage() async {
    Navigator.of(context)
        .pushReplacement(new MaterialPageRoute(builder: (_) => StudentHomePage()));

  }

  @override
  Widget build(BuildContext context) {
    this.context = context;

    final professorLogo = new Hero(
      tag: 'professor-logo',
      child: new CircleAvatar(
        child: new Container(
            width: 150.0,
            height: 150.0,
            decoration: new BoxDecoration(
              color: const Color(0xff7c94b6),
              image: new DecorationImage(
                image: new AssetImage("assets/professor.png"),
              ),
              borderRadius: new BorderRadius.all(new Radius.circular(80.0)),
            )),
      ),
    );

    final studentLogo = new Hero(
      tag: 'student-logo',
      child: new CircleAvatar(
        child: new Container(
          width: 150.0,
          height: 150.0,
          decoration: new BoxDecoration(
            color: const Color(0xff7c94b6),
            image: new DecorationImage(
              image: new AssetImage("assets/student.png"),
            ),
            borderRadius: new BorderRadius.all(new Radius.circular(80.0)),
          ),
        ),
      ),
    );

    return new Scaffold(
      appBar: new MyAppBar().createAppbar("FRAttendence"),
      body: new Builder(
        builder: (BuildContext context) {
          _scaffoldContext = context;

          return new Container(
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                begin: Alignment.topCenter,
                end: new Alignment(1.0, 5.0),
                // 10% of the width, so there are ten blinds.
                colors: [Colors.white, Colors.blueAccent], // whitish to gray
              ),
            ),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new Column(
                  children: <Widget>[
                    new Container(
                      width: 150.0,
                      height: 150.0,
                      child: professorLogo,
                      margin: const EdgeInsets.all(16.0),
                    ),
                  ],
                ),
                new Container(
                  child: new RaisedButton(
                    padding: new EdgeInsets.all(16.0),
                    color: Colors.blueAccent,
                    elevation: 20.0,
                    onPressed: () {
                      openProfessorLoginpage();
                    },
                    child: new Text("Professor", style: btnLable),
                    shape: new RoundedRectangleBorder(
                        borderRadius:
                        new BorderRadius.all(new Radius.circular(60.0))),
                  ),
                  margin: new EdgeInsets.only(
                      bottom: 16.0, left: 16.0, right: 16.0),
                ),
                new Column(
                  children: <Widget>[
                    new Container(
                      width: 150.0,
                      height: 150.0,
                      child: studentLogo,
                      margin: const EdgeInsets.all(16.0),
                    ),
                  ],
                ),
                new Container(
                  child: new RaisedButton(
                    padding: new EdgeInsets.all(16.0),
                    color: Colors.blueAccent,
                    elevation: 20.0,
                    onPressed: () {

                      openStudentLoginPage();
                    },
                    child: new Text("Student", style: btnLable),
                    shape: new RoundedRectangleBorder(
                        borderRadius:
                        new BorderRadius.all(new Radius.circular(60.0))),
                  ),
                  margin: new EdgeInsets.only(
                      bottom: 16.0, left: 16.0, right: 16.0),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
