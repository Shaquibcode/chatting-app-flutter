import 'dart:convert';

import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

class FcmHelper{
  static const _SCOPES = [
    //'https://www.googleapis.com/auth/cloud-platform.read-only',
    'https://www.googleapis.com/auth/firebase.messaging',
  ];

  Future<String> getAccessToken() async {
    String accessToken = "";
    ServiceAccountCredentials _credentials =
    ServiceAccountCredentials.fromJson(
        {
          "type": "service_account",
          "project_id": "chattingapp-dea25",
          "private_key_id": "603f7d36be71b336898aa98842d7d9b2235165c9",
          "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDN4lKw36RzyPsb\n6JVVje9UcJby45keR508jPMhctX9Wgiad9pnUobTDoMJQmBDUkgrZ3eJHqZdBnob\nYNYrX5P07P42bM6qDUT7pdBv7jY7iP+dvTvbNW7ul3VW7ybm2+EApxPNVg33lMib\nKZSrd9ZTFhm1pP/5qHnoc6KE0JK1b3rnPgeRQdOTKTdoIlxhYetHk5b5xZS/Ssdc\npdAdxOadzayD16rUJjlsWZ/5Ca7WwiGHeihPLqzoQsnhva29Jd+qFHzL2SyMqsnJ\nih3p8P8uEQj/b4OKrLtCwZzdXtmUOGFE1s2mCwS977fJ8fM9tyPwr4EoVnNrhhwt\nn3MtgTfJAgMBAAECggEABFsnpf2jXn5H/toLz9K4F7ymmvbBEnyQKXvveHuUJr9B\nC5ih1roOp3hJAjkE7aO36nAu3ag3+6OjkYD54xLLf/0EL21brYoolZz3ZSjgfZ+7\nTdB3S97sbRCoD0nx1CRelTuTvg5WLxD3Mh49+qdHUfx3mInoTxVXF/mbXI1Hr15F\n32lGQWMBcKEWWBlgbYBPrWLRUB6OuhzdmZhkT4rq2Xsm5o1cbpF0as4qohvGtWP6\nYxHfq3BabrI9Veeze+pXxuNTavuCFmCw5mUVvlGI6fuAsAKGrLPgFOlT7OK1p9J2\n3El1LDxNQdRpINEumYF/DXAE55O9jusRSqwzLG8eYQKBgQDpk1Uu1h3hsZ5LNpvg\nZxGK1U7mbAzOVOiJYXIjIhTE+iKsZfHf+6TC3SVhrHeaDR7z5sm+HhYGasRCkivt\nlxwMbYTguo/YgMyhvkyBuhwcSuin+752KOgiK80W98aTZh0sIglS39P2w4JD68Cr\nhhPg6yhBzv6K38hIM+vIJbVwaQKBgQDhpmhvYAE+ukhZPzc7FT9hubHJd0qJ3+al\nMQsfZBherOAriMSWLC7ZE2xhJEVQCxL79LCOIplslE8wxCCq6zMHgspPC/ga80ju\ncwvr6i2ZkQo1TZfFc/GjoR1O6N649loJisceGuQ6+nc+yyRw9+/2BheOz39A+Rsv\nM/lv4YCgYQKBgD2/Khyok9uvJcaCWDC5boTCIQp+89+zyIlQzmiFQPJVocbraEaq\n8oJlDdXFTxTVdSJLF3f/4hiuLtXeaGh1sv+CEEeMaix02CPF99mvhnDgSKLnxRDd\nfYhTBfOVatRagUnCca6L5y/rvUsRTqzJVAX4hHrpKpcx03Nq7mDJvy5JAoGBAMJf\netR9iXUEN/AQwT22tssyjw/xHxcW9HHVhjQ7H7bmCY/WlyiY1J4O2ivvd3lUoLzC\ncRdufGSIeJKUT2OLiIBuzGA8+jIU4PztwxYrua3vvzBdL2BZ2ItP7JQdikUfiD1x\n+sVW+sRHHlLL4A8js+NkKgTNflt0eVM23SXfxNHhAoGAT+/GdrgjQLJAhXgdswq0\nm+FRLa1BPapLmLd3bQXoJUue/ujfbc+jr4194lxGE1WR0X5kyHQQkso6tlBZPQWB\nzYf7v9dJhgCCmyzC4boFTLUFxx/iN4Bwc3rk8OTkGKb2f7MonIwO6aC8cNs5fV4k\nprwyHTdYU8iOHhfPi9rQ310=\n-----END PRIVATE KEY-----\n",
          "client_email": "firebase-adminsdk-tx1sr@chattingapp-dea25.iam.gserviceaccount.com",
          "client_id": "103014704917945046834",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-tx1sr%40chattingapp-dea25.iam.gserviceaccount.com"
        }
    );
    final credentials = _credentials;
    final accessCredentials = await obtainAccessCredentialsViaServiceAccount(
      credentials,
      _SCOPES,
      http.Client(),
    );
    accessToken = accessCredentials.accessToken.data;

    return accessToken;
  }

  Future<void> sendNotification(String fcmToken, String title, String body,
      {String? imageUrl}) async {
    await getAccessToken().then((accessToken) async {
      var headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      };
      var request = http.Request(
          'POST',
          Uri.parse(
              'https://fcm.googleapis.com/v1/projects/chattingapp-dea25/messages:send'));
      request.body = json.encode({
        "message": {
          "token": fcmToken,
          "notification": {"title": title, "body": body}
        }
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
      } else {}
    });
  }
}