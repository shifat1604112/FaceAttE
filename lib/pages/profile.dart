import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_net_authentication/pages/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'home.dart';
import 'dart:math' as math;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:fluttertoast/fluttertoast.dart';


class Profile extends StatefulWidget {
  final String username;
  final String imagePath;
  const Profile(this.username, {Key key, this.imagePath}) : super(key: key);
  @override
  _CourseState createState() => _CourseState();
}

class _CourseState extends State<Profile> {
  String currentAddress = 'My Address';
  Position currentposition;
  var selectedCourse, selectedType;
  final GlobalKey<FormState> _formKeyValue = new GlobalKey<FormState>();
  List<String> _accountType = <String>[
    'Course 1',
    'Course 2',
    'Course 3',
    'Course 4'
  ];
  TextEditingController name = TextEditingController();
  TextEditingController id = TextEditingController();
  String Name,ID;


  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: 'Please enable Your Location Service');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: 'Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg:
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    try {
      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);

      Placemark place = placemarks[0];

      setState(() {
        currentposition = position;
        currentAddress =
        "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState(){
    _determinePosition();
  }

  clearTextInput(){
    name.clear();
    id.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: FileImage(File(widget.imagePath)),
                ),
              ),
            ),
          ),
          title: Container(
            alignment: Alignment.center,
            child:Text(
                'Hi ' + widget.username + '!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
          ),
        ),
        body: Form(
          key: _formKeyValue,
          //autovalidate: true,
          child: new ListView(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            children: <Widget>[
              SizedBox(height: 10.0),
              new TextField(
                  controller: id,
                  decoration: const InputDecoration(
                    icon: const Icon(
                      FontAwesomeIcons.idBadge,
                      color: Colors.blue,
                    ),
                    hintText: 'Enter your ID',
                    labelText: 'ID',
                  ),
                  keyboardType: TextInputType.number,
              ),
              new TextFormField(
                controller: name,
                decoration: const InputDecoration(
                  icon: const Icon(
                    FontAwesomeIcons.userCircle,
                    color: Colors.blue,
                  ),
                  hintText: 'Enter your Name',
                  labelText: 'Name',
                ),
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.bookOpen,
                    size: 25.0,
                    color: Colors.blue,
                  ),
                  SizedBox(width: 50.0),
                  DropdownButton(
                    items: _accountType
                        .map((value) => DropdownMenuItem(
                      child: Text(
                        value,
                        style: TextStyle(color: Colors.blue,),
                      ),
                      value: value,
                    ))
                        .toList(),
                    onChanged: (selectedAccountType) {
                      print('$selectedAccountType');
                      setState(() {
                        selectedType = selectedAccountType;
                      });
                    },
                    value: selectedType,
                    isExpanded: false,
                    hint: Text(
                      'Choose Course',
                      style: TextStyle(color: Colors.blue),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  RaisedButton(
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text("Submit", style: TextStyle(fontSize: 24.0)),
                            ],
                          )),
                      onPressed: () {
                        DateTime dateToday = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day) ;
                        //print(dateToday);
                        //print(currentAddress);
                        clearTextInput();
                        FirebaseFirestore.instance
                            .collection('studentDetails')
                            .add({'CourseName': selectedType,'id' : id.text,'name': name.text,'location':currentAddress,'date' : dateToday });
                      },
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0))),
                ],
              ),
            ],
          ),
        ));
    }
}
