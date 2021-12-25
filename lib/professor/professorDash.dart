import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfessorDashboard extends StatefulWidget {
  //const ProfessorDashboard({Key? key}) : super(key: key);
  @override
  _ProfessorDashboardState createState() => _ProfessorDashboardState();
}

class _ProfessorDashboardState extends State<ProfessorDashboard> {
  TextEditingController searchEditingController = new TextEditingController();
  QuerySnapshot searchResultSnapshot;
  Stream chatRooms;

  bool isLoading = true;
  bool haveUserSearched = false;

  String name = "";

  @override
  void initState() {
    //getUserInfogetChats();
  }
  getUserInfogetChats() async {
    setState(() {
      chatRooms = FirebaseFirestore.instance.collection('studentDetails').where("id", isEqualTo:name).snapshots();
      if(chatRooms==null)
        isLoading = true;
      else
        isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Card(
          child: TextField(
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.search), hintText: 'Search...'),
            onChanged: (val) {
              setState(() {
                name = val;
              });
            },
          ),
        ),
        actions: <Widget>[
           IconButton(
             icon: Icon(Icons.search),
                onPressed: () {
                  getUserInfogetChats();
              },
         ),
        ],
      ),
      body: isLoading ? Container(
        child: Center(
          child: CircularProgressIndicator()
        ),
      ) : SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child:  MessagesStream(name)
          )
      )
      /*SafeArea(
          child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(name),
          ]
        )
      )*/
      );
  }
}



class MessagesStream extends StatelessWidget {

  String name = "";
  MessagesStream(@required this.name);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('studentDetails').where("id", isEqualTo:name).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data.docs.reversed;
        return DataTable(
          columnSpacing: 45,
          columns: const <DataColumn>[
            DataColumn(
              label: Text(
                'Course Name',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            DataColumn(
              label: Text(
                'Id',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            DataColumn(
              label: Text(
                'Date',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ],
          rows: snapshot.data.docs.map((element) => generateRows(element['CourseName'], element['id'],element['date'].toDate().toString())).toList(),
        );
      },
    );
  }
}

    DataRow generateRows(String crsname,String id, String date){
      return DataRow(
        cells: <DataCell>[
          DataCell(Text(crsname)),
          DataCell(Text(id)),
          DataCell(Text(date)),
        ],
      );
    }


class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.text});

  final String sender;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Text(
            sender,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black,
            ),
          ),
          Material(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}