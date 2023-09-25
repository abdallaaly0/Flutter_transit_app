import 'dart:convert';
import 'package:http/http.dart' as http;
import 'entites/data.dart';

//This class is used for fetching and serving data to app

class DataFetcher {
  //URL were API server is running
  static const baseURL = "http://192.168.1.250:5000";
  static const atrainEndpoint =
      "$baseURL/api/train-time"; //Adds '/Atrain' to baseURL

  /* Function for getting data from API */
  // Future<Data> fetchPost() async {
  //   final url = Uri.parse(postsEndpoint);
  //   print(url);
  //   final response = await http.get(url);
  //   if (response.statusCode == 200) {
  //     return Data.fromJson(jsonDecode(response.body));
  //   } else {
  //     throw Exception('Failed to load post:');
  //   }
  // }

  Future<int> fetchATrainData() async {
    final url = Uri.parse(atrainEndpoint);
    print(url);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['train time'];
    } else {
      throw Exception('Failed to load post:');
    }
  }
}
