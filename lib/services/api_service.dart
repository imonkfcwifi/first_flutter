import 'package:http/http.dart' as http;

// get -> http로 쓸수있음
class ApiService {
  final String baseUrl = "https://webtoon-crawler.nomadcoders.workers.dev";
  final String today = "today";

  void getToons() async {
    final url = Uri.parse('$baseUrl/$today');
    // base url 만들기
    final response = await http.get(url);
    // API 서버에 요청 보내기
    // API가 네트워크 문제 .서버메모리. . .등등으로 오래 걸리수 있어
    // Dart가 hhtp.get(url)의 응답을 기다리게 한다. (async)
    // 서버에서 요청을 처리하고 응답을 주는것을 기다리고
    // 응답을 response 변수에 저장함
    if (response.statusCode == 200) {
      print(response.body);
      // response의 body에는 서버가 보낸 데이터가 있음
      return;
    }
    throw Error();
  }
}

// pub.dev는 node js의 npm 이나 python의 PyPI와 비슷한 개념임
