import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:job_extra/models/route_arguments.dart';
import 'package:job_extra/pages/payment/payment_page_screen.dart';

class JobDetailPage extends StatefulWidget {
  static String routeName = "/job_details";

  @override
  _JobDetailPageState createState() => _JobDetailPageState();
}

class _JobDetailPageState extends State<JobDetailPage> {
  @override
  Widget build(BuildContext context) {
    final RouteArgument argument = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("Job Details"),
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('jobs')
              .doc(argument.job_id)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              return JobDetailInformation(document: snapshot.data);
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

class JobDetailInformation extends StatelessWidget {
  final DocumentSnapshot document;
  const JobDetailInformation({
    Key key,
    this.document,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: size.height * 0.3,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(document['cover']), fit: BoxFit.cover)),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              document['about_company'],
              style: TextStyle(fontSize: 18),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Text('Qualifications', style: TextStyle(fontSize: 25),),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Text(convertToString(document['qualifications']), style: TextStyle(fontSize: 18),)
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Text('Responsibilities', style: TextStyle(fontSize: 25),),
          ),
          Container(
              padding: EdgeInsets.all(10),
              child: Text(convertToString(document['responsibilities']), style: TextStyle(fontSize: 18),)
          ),
          Container(
            width: size.width,
            height: size.height * .2,
            child: Center(
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context,PaymentPageScreen.routeName);
                },
                child: Container(
                  height: 50,
                  width: 150,
                  child: Center(child: Text('Pay Now', style: TextStyle(fontSize: 20, color: Colors.white),)),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  String convertToString(document) {
    String para = "-\t";
    for(int i = 0; i < document.length; i++) {
      para = para + document[i] + "\n\n-\t";
    }
    return para;
  }
}
