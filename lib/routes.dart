import 'package:flutter/material.dart';
import 'package:job_extra/pages/details/job_details_page.dart';
import 'package:job_extra/pages/home/home_page.dart';
import 'package:job_extra/pages/payment/payment_page_screen.dart';

final Map<String, WidgetBuilder> routes = {
    HomePage.routeName: (context) => HomePage(),
    JobDetailPage.routeName: (context) => JobDetailPage(),
    PaymentPageScreen.routeName: (context) => PaymentPageScreen()
};