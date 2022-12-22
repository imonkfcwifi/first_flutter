import 'dart:convert';

import 'package:flu/models/webtoon.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      "https://webtoon-crawler.nomadcoders.workers.dev";
  static const String today = "today";

  static Future<List<WebtoonModel>> getToons() async {
    List<WebtoonModel> toonsList = [];
    final url = Uri.parse('$baseUrl/$today');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> webtoons = jsonDecode(response.body);
      for (var webtoon in webtoons) {
        toonsList.add(WebtoonModel.fromJson(webtoon));
      }
      return toonsList;
    }
    throw Error();
  }
}

// pub.dev는 node js의 npm 이나 python의 PyPI와 비슷한 개념임
