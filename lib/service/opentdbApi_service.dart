import 'dart:convert';
import 'package:http/http.dart' as http;

var link = "https://opentdb.com/api.php?amount=50&category=15";

getQuiz() async {
  var res = await http.get(Uri.parse(link));
  if (res.statusCode == 200) {
    var data = jsonDecode(res.body.toString());
    print("Data is loaded");
    return data;
  }
}

