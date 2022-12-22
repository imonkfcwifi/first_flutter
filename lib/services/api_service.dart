import 'dart:convert';

import 'package:flu/models/webtoon.dart';
import 'package:http/http.dart' as http;

// get -> http로 쓸수있음
class ApiService {
  static const String baseUrl =
      "https://webtoon-crawler.nomadcoders.workers.dev";
  static const String today = "today";
// 아무리 많은 인스턴스를 생성한다 하더라도, static으로 선언된 변수는 클래스에
// 직접 접근하여 한번만 변경해도 모든게 바뀐다.

  static Future<List<WebtoonModel>> getToons() async {
    List<WebtoonModel> toonsList = [];
    final url = Uri.parse('$baseUrl/$today');
    // base url 만들기
    final response = await http.get(url);
    // API 서버에 요청 보내기
    // API가 네트워크 문제 .서버메모리. . .등등으로 오래 걸리수 있어
    // Dart가 hhtp.get(url)의 응답을 기다리게 한다. (async)
    // 서버에서 요청을 처리하고 응답을 주는것을 기다리고
    // 응답을 response 변수에 저장함
    if (response.statusCode == 200) {
      final List<dynamic> webtoons = jsonDecode(response.body);
      // response의 body에는 서버가 보낸 데이터가 있음
      for (var webtoon in webtoons) {
        // 단순한 String Text로 된 응답 body를 JSON List으로 디코딩한다.
        toonsList.add(WebtoonModel.fromJson(webtoon));
      }
      return toonsList;
    }
    throw Error();
  }
}

// pub.dev는 node js의 npm 이나 python의 PyPI와 비슷한 개념임
