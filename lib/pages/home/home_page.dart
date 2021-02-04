import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:job_extra/models/route_arguments.dart';
import 'package:job_extra/pages/details/job_details_page.dart';

class HomePage extends StatefulWidget {
  static String routeName = "/home_page";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Job Extra"),
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('jobs').snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              final List<QueryDocumentSnapshot> documents = snapshot.data.docs;
              return ListView.builder(
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, JobDetailPage.routeName, arguments: RouteArgument(
                        job_id: documents[index].id
                      ));
                    },
                    child: Card(
                      child: ListTile(
                        title: Text(
                          documents[index]['title'],
                          style: TextStyle(fontSize: 20),
                        ),
                        subtitle: Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text(documents[index]['about_company'])),
                        // leading: Image.network("gs://jobetra-44ed6.appspot.com/IMG_20210128_100134_375.jpg"),
                      ),
                    ),
                  );
                },
                itemCount: documents.length,
              );
            }
            return Center(
              child: SizedBox(
                  height: 100, width: 100, child: CircularProgressIndicator()),
            );
          },
        ),
      ),
    );
  }
}
