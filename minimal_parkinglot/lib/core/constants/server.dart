import 'dart:io';

class ServerConstants {
  static String baseUrl =
      Platform.isAndroid ? 'http://192.168.1.9:5000' : 'http://localhost:5000';
}

//  'http://10.0.2.2:5000'
