import 'package:flu/models/webtoon.dart';
import 'package:flu/services/api_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final Future<List<WebtoonModel>> webtoons = ApiService.getToons();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.amber,
        title: const Text(
          "오늘의 웹툰",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: FutureBuilder(
        future: webtoons,
        builder: (context, snapshot) {
          // snapshot은 Future의 상태를 의미
          // 로딩중인지 데이터가 있는지 에러가 났는지 알수있음
          // Widget Function(BuildContext, AsyncSnapshot<List<WebtoonModel>>
          if (snapshot.hasData) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              // 좌우로 스크롤
              itemCount: snapshot.data!.length,
              // webtoon의 크기
              itemBuilder: (context, index) {
                var webtoon = snapshot.data![index];
                // ListView Builder는 최적화 되어있는 ListView임, 사용자가 보고있는 아이템만 Build함
                // 사용자가 보고있지 않은 아이템은 메모리에서 삭제함
                return Text(webtoon.title);
              },
            );
            // 많은 양의 데이터를 연속적으로 보여주고 싶을 때
            // Cloumm 과 Row는 딱히 적합하지 않음
            // ListView 는 여러항목을 나열하는데 최적화된 widget임
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
