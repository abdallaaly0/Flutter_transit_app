import 'dart:convert';
import 'package:http/http.dart' as http;
import 'entites/data.dart';
//Class for handeling HTTP request to flask API

class PostClient {
  //URL were API server is running
  static final baseURL = "http://192.168.1.250:5000";
  static final postsEndpoint = baseURL + "/Atrain"; //Adds '/Atrain' to baseURL

  /* Function for getting data from API */
  Future<Data> fetchPost() async {
    final url = Uri.parse(postsEndpoint);
    print(url);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return Data.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load post:');
    }
  }
}
