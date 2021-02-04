import 'package:dio/dio.dart';
import 'package:job_extra/services/secrets.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';

class PaymentGateway {
  PaymentGateway._privateConstructor();

  static final PaymentGateway instance = PaymentGateway._privateConstructor();

  bool successful = false;

  startTransaction(String amountToPay, String clientPhone, String ref, String token) async {
    String url =
        "https://sandbox.momodeveloper.mtn.com/collection/v1_0/requesttopay";
    Map map = {
      "amount": amountToPay,
      "currency": "EUR",
      "externalId": ref,
      "payer": {"partyIdType": "MSISDN", "partyId": clientPhone},
      "payerMessage": "Payment for your Bus Ticket",
      "payeeNote": "Thank you for using Commuter"
    };

    apiRequest(url, map, token);
  }


  // step 1
  void makePayment(String amount, String phone) async {
    var uuid = Uuid();
    var ref = uuid.v4();
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(
        Uri.parse('https://sandbox.momodeveloper.mtn.com/v1_0/apiuser'));
    request.headers
        .set('Content-Type', 'application/json', preserveHeaderCase: true);
    request.headers.set('X-Target-Environment', Secrets.MTN_MOMO_ENVIRONMENT,
        preserveHeaderCase: true);
    request.headers.set('X-Reference-Id', ref, preserveHeaderCase: true);
    request.headers.set(
        'Ocp-Apim-Subscription-Key', Secrets.MTN_MOMO_SUBSCRIPTION_KEY,
        preserveHeaderCase: true);
    request.add(utf8.encode(json.encode({"providerCallbackHost": "string"})));

    HttpClientResponse response = await request.close();
    // String reply = await response.transform(utf8.decoder).join();

    httpClient.close();

    if(response.statusCode == 201) {
      getUser(ref, amount, phone);
    }
  }

  void getUser(String ref, String amount, String phone) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.getUrl(
        Uri.parse('https://sandbox.momodeveloper.mtn.com/v1_0/apiuser/$ref'));
    request.headers
        .set('Content-Type', 'application/json', preserveHeaderCase: true);
    request.headers.set('X-Target-Environment', Secrets.MTN_MOMO_ENVIRONMENT,
        preserveHeaderCase: true);
    request.headers.set('X-Reference-Id', ref, preserveHeaderCase: true);
    request.headers.set(
        'Ocp-Apim-Subscription-Key', Secrets.MTN_MOMO_SUBSCRIPTION_KEY,
        preserveHeaderCase: true);

    HttpClientResponse response = await request.close();
    // String reply = await response.transform(utf8.decoder).join();

    httpClient.close();

    if(response.statusCode == 200) {
      getUserKey(ref, amount, phone);
    }
  }

  void getUserKey(String ref, String amount, String phone) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(
        Uri.parse('https://sandbox.momodeveloper.mtn.com/v1_0/apiuser/$ref/apikey'));
    request.headers
        .set('Content-Type', 'application/json', preserveHeaderCase: true);
    request.headers.set('X-Target-Environment', Secrets.MTN_MOMO_ENVIRONMENT,
        preserveHeaderCase: true);
    request.headers.set('X-Reference-Id', ref, preserveHeaderCase: true);
    request.headers.set(
        'Ocp-Apim-Subscription-Key', Secrets.MTN_MOMO_SUBSCRIPTION_KEY,
        preserveHeaderCase: true);

    HttpClientResponse response = await request.close();


    if(response.statusCode == 201) {
      String reply = await response.transform(utf8.decoder).join();
      Map<String, dynamic> data = jsonDecode(reply);
      print(data['apiKey']);
      getAccessToken(ref, data['apiKey'], amount, phone);
    }

    httpClient.close();
  }

  Future<bool> apiRequest(String url, Map jsonMap, String token) async {
    var uuid = Uuid();
    bool isPreserveHeaderCase = true;
    String requestId = uuid.v4();
    String auth = 'Bearer ' + token;
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('Content-Type', 'application/json',
        preserveHeaderCase: isPreserveHeaderCase);
    request.headers
        .set('Authorization', auth, preserveHeaderCase: isPreserveHeaderCase);
    request.headers.set('X-Target-Environment', Secrets.MTN_MOMO_ENVIRONMENT,
        preserveHeaderCase: isPreserveHeaderCase);
    request.headers.set('X-Reference-Id', requestId,
        preserveHeaderCase: isPreserveHeaderCase);
    request.headers.set(
        'Ocp-Apim-Subscription-Key', Secrets.MTN_MOMO_SUBSCRIPTION_KEY,
        preserveHeaderCase: isPreserveHeaderCase);
    request.add(utf8.encode(json.encode(jsonMap)));
    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();
    httpClient.close();
    print(response.reasonPhrase);
    print("${response.statusCode}");
    print("${response.headers}");
    print("${response.connectionInfo}");
    print(request.headers);
    print("${response.statusCode}");
    if (response.statusCode == 200) {
      print('Transaction is successful');
    } else {
      successful = true;
    }

    return successful;
  }

  void getAccessToken(String ref, String apiKey, String amount, String phone) async {
    String username = ref;
    String password = apiKey;
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));

    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(
        Uri.parse('https://sandbox.momodeveloper.mtn.com/collection/token/'));
    request.headers
        .set('Content-Type', 'application/json', preserveHeaderCase: true);
    request.headers.set('X-Target-Environment', Secrets.MTN_MOMO_ENVIRONMENT,
        preserveHeaderCase: true);
    request.headers.set('X-Reference-Id', ref, preserveHeaderCase: true);
    request.headers.set(
        'Ocp-Apim-Subscription-Key', Secrets.MTN_MOMO_SUBSCRIPTION_KEY,
        preserveHeaderCase: true);

    request.headers.set('Authorization', basicAuth, preserveHeaderCase: true);

    HttpClientResponse response = await request.close();


    if(response.statusCode == 200) {
      String reply = await response.transform(utf8.decoder).join();
      Map<String, dynamic> data = jsonDecode(reply);
      print(data['access_token']);
      startTransaction(amount, phone, ref, data['access_token']);
    }

    httpClient.close();
  }
}
