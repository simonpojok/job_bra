import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:job_extra/services/payment_gateway.dart';
import 'package:uuid/uuid.dart';

class PaymentPageScreen extends StatefulWidget {
  static String routeName = "/make_payment_for_seats";

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<PaymentPageScreen> {
  String _payment_method = 'mobile_money';
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: Text("Review"),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: size.width,
                  height: size.height * 0.15,
                  color: Colors.grey.shade300,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Contact Information',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                            fontSize: 25),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          'Please specify the name and information to be printed on your ticket',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.black54,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  child: Form(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: size.width * 0.4,
                              margin: EdgeInsets.only(right: 10),
                              child: TextFormField(
                                controller: _firstNameController,
                                decoration: InputDecoration(
                                  labelText: 'First Name',
                                  labelStyle: TextStyle(
                                    color: Color(0xFF6200EE),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFF6200EE)),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: size.width * 0.4,
                              child: TextFormField(
                                controller: _lastNameController,
                                decoration: InputDecoration(
                                  labelText: 'Last Name',
                                  labelStyle: TextStyle(
                                    color: Color(0xFF6200EE),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFF6200EE)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              color: Color(0xFF6200EE),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF6200EE)),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: size.width * 0.1,
                              margin: EdgeInsets.only(right: 10),
                              child: TextFormField(
                                initialValue: '+256',
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(
                                    color: Color(0xFF6200EE),
                                  ),
                                  enabled: false,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFF6200EE)),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: size.width * 0.7,
                              child: TextFormField(
                                controller: _phoneNumberController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  labelText: 'Phone Number',
                                  labelStyle: TextStyle(
                                    color: Color(0xFF6200EE),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFF6200EE)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: size.width,
                  height: size.height * 0.15,
                  color: Colors.grey.shade300,
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Payment Option',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                            fontSize: 25),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          'Select your payment option to pay for your tickets',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.black54,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text('Mobile Money'),
                        leading: Radio(
                          value: 'mobile_money',
                          groupValue: _payment_method,
                          onChanged: (String value) {
                            setState(() {
                              _payment_method = value;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Wallet'),
                        leading: Radio(
                          value: 'wallet',
                          groupValue: _payment_method,
                          onChanged: (String value) {
                            setState(() {
                              _payment_method = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.blueGrey,
          child: Container(
            height: size.height * 0.08,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    child: Container(
                      width: 100,
                      height: 50,
                      color: Colors.green,
                      child: Center(
                          child: Text(
                        'Pay Now',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                    onTap: () {
                      handlePayment(context);
                    },
                  )
                ],
              ),
            ),
          ),
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  void handlePayment(BuildContext context) async {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularProgressIndicator(),
                Text("Processing Payment"),
                FlatButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        );
      },
    );
    await PaymentGateway.instance.makePayment('5000', _phoneNumberController.text);
    Navigator.pop(context);
    showDialog(context: context, builder: (context) => AlertDialog(
      title: Text('Payment Successful'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Payment for job application recieved suceesfully'),
            Text('Please check your email for more'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Done'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    ));

  }
}
