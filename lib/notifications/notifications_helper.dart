// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:http/http.dart' as http;
// import 'package:googleapis_auth/auth_io.dart' as auth;
// import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;
// //import 'package:connectivity_plus/connectivity_plus.dart';

// class NotificationService {
//   static Future<String> getAccessToken() async {
//     final serviceAccountJson = {
//   "type": "service_account",
//   "project_id": "fir-26fef",
//   "private_key_id": "585857b094c98e778f2f4be71312c12cdc514374",
//   "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQDYFcqmgvFxSHXK\nB1qEHdgCTYn1mL2DE91p+SWV80b5mxJuTFoxNZhUxcTvA2IObmY+oF2UCOl/7T78\n0OPAocn0Sbl7zWzJha1p8QDlw6wdLC4hDVVKKqctrAXspj2tNycJJpoeOVidSKSo\nT2pROdzLNGjlL6qbxWQ1NFw6F5hXIJU9E6MBDtbCS+0hcKGFwL0HuMOc3RkS2UVw\nzmrJ5t644E12/TUr3ezMIWh2UVK92xNCg/KK4YtIjYSHcRuQMQ1GWWu5V+rt93Zl\ntrgwdGRAzc2ow34zzkR9ta7HkBztP8LhwordZC+z6aGAhLZ9gJEiIXRzz3zckkt9\npYbvMTyPAgMBAAECggEADLqdf6X5CRftCf1y58asrqRyR9hujLLDEt1AliiIxs1l\nJ/NkrYw45AC4DO7H4o4lHo1RCRZmHHx75TKwJ+0GU4pAQrqJxp+sS0nzwchlpcMW\nsijx6RBbXSv9nib3PSWH+ovRylpm2ot1jHPZKt3CU7blP8YvqHg+FfBDeo/HQ2KM\ndFyfCx2fg64LL7COGX1E7tkG/TP48H9Ol96VvJ0WN9A85CJ+VXWw86OmPj90y0RL\nAdUOESHjxBXY8/7Sel3Yvh6qWq0ovhacJIyyPlujHNzVYFNK+DstbujuWkM1axv5\ni8PeEbOjidi9NkBkhqSAjZu6dndq+rDv62N0L0vNaQKBgQDziQBiyoBBZsFKnXos\ny09BeWj9VXrD6nKl2UttAxE1fWTNJRTSCfz8m4V3YjlV7C87unhxq3+uWt/H84fm\nPSaxivicEZG9NRYxGMbtXtWbGi8D6WOwkRJTZRWCk3jmZ2IJkFdtm1ii4g+Nn0X8\nL8YXKa/YH242hfFMg9qP8x/q7QKBgQDjJR33YaDNvdf5u2cNeq5GaBRRVLOvzNy3\nmRP8hFK8Ej8f9W56BqZU9ekfRwpZ7Lho2aSfPmwHUOfLwphzMXcxoHEvX1eBH/u9\nbp679ipdloDurBYgIauIPVMTT48qAkQQhVotG7ycYkWd6c/lqywDqhlA1Yj6jQ/8\njb9gGqNJ6wKBgQDrRVJzHjCzfiKEBAiw16T0mucbvoXAWXFy2a6tXMY2R7KnIQix\nNWcLXu+ceu7rHCYxbJ7JKaZK+Y2xLIsAmdkUsi4lEDAcevm6arZbQT/Y/H2pKMLf\nI/dxS3lxUSj+Zafnl2NvByGlEgF2jwVccYbMf8BaaVrfH50Sj1sJsBYIrQKBgQCF\nNWVHiMenIOiiGlcrPoEp5SvVLplaRghC29Euy+NBTGocsfCiO3gcZ0LaBu15Iyxa\nwRicEx2DhN0LUAnbtGy0e+Uk5QMKRNl7lH4euRTLYdInJmCrY1OXSG+J6aSJ/F4y\nWiIyRgvsom01WMOFa0catwysSw5T8ZoogHB1SentFQKBgQDGR6Xz/T3tkQ5fJfEd\nWzxO4ATwGmx46n9HN9QTIweeO4AKbDranqalAtpobfrmDSxKoGtdeT0yPqJDPsaz\n4yhL93Z4DyEcZjaeRAyxNMdaTGqI7GnL62Wgnn5p0GJ12iA/fDgSt7okGw6OBH1b\n4z9YwwElhsWaHKlokuThl2Md7A==\n-----END PRIVATE KEY-----\n",
//   "client_email": "mdm-flu@fir-26fef.iam.gserviceaccount.com",
//   "client_id": "102536056284194574932",
//   "auth_uri": "https://accounts.google.com/o/oauth2/auth",
//   "token_uri": "https://oauth2.googleapis.com/token",
//   "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
//   "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/mdm-flu%40fir-26fef.iam.gserviceaccount.com",
//   "universe_domain": "googleapis.com"
// };
//     List<String> scopes = [
//       "https://www.googleapis.com/auth/userinfo.email",
//       "https://www.googleapis.com/auth/firebase.database",
//       "https://www.googleapis.com/auth/firebase.messaging",
//     ];
//     http.Client client = await auth.clientViaServiceAccount(
//       auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
//       scopes,
//     );
//     auth.AccessCredentials credentials = await auth
//         .obtainAccessCredentialsViaServiceAccount(
//           auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
//           scopes,
//           client,
//         );
//     client.close();
//     return credentials.accessToken.data;
//   }

//   static Future<void> sendNotification(
//     // String deviceToken,
//     // String title,
//     // String body,
//     // Map<String, dynamic> data, 
//     {
//       required String deviceToken,
//       required String title,
//       required String body,
//       required Map<String, dynamic> data,
//     required bool includeNotification,
//   }) async {
//     final String accessToken = await getAccessToken();
//     String endpointFCM =
//         'https://fcm.googleapis.com/v1/projects/fir-26fef/messages:send';
//     final Map<String, dynamic> message = {
//       "message": {
//         "token": deviceToken,
//         "notification": {"title": title, "body": body},
//         "data": data,
//       },
//     };

//     final http.Response response = await http.post(
//       Uri.parse(endpointFCM),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $accessToken',
//       },
//       body: jsonEncode(message),
//     );

//     if (response.statusCode == 200) {
//       print('Notification sent successfully');
//       //Get.defaultDialog(title: title, middleText: body);
//     } else {
//       print('Failed to send notification');
//     }
//   }
// }


import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;

class NotificationService {
  // 🔐 جلب توكن الخدمة
  static Future<String> getAccessToken() async {
    final file = File('lib/secrets/service_account.json');
    final serviceAccountJson = json.decode(await file.readAsString());

    
    final scopes = [
      "https://www.googleapis.com/auth/firebase.messaging",
    ];

    final client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    final credentials = await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
      client,
    );

    client.close();
    return credentials.accessToken.data;
  }

  // ✉️ إرسال رسالة FCM من نوع data فقط
  static Future<void> sendNotification({
    required String deviceToken,
    required Map<String, dynamic> data,
  }) async {
    final accessToken = await getAccessToken();

    final endpoint = 'https://fcm.googleapis.com/v1/projects/fir-26fef/messages:send';

    final Map<String, dynamic> message = {
      "message": {
        "token": deviceToken,
        "data": data, // لا ترسل notification أبداً
      }
    };

    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      print('✅ تم إرسال الأمر بنجاح');
    } else {
      print('❌ فشل إرسال الأمر: ${response.statusCode}');
      print(response.body);
    }
  }
}
