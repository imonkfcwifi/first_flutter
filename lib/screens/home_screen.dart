import 'package:flu/models/webtoon.dart';
import 'package:flu/services/api_service.dart';
import 'package:flu/widgets/webtoon_widget.dart';
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
        foregroundColor: Colors.black.withOpacity(0.5),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "오늘의 웹툰",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        future: webtoons,
        builder: (context, snapshot) {
          // snapshot은 Future의 상태를 의미
          // 로딩중인지 데이터가 있는지 에러가 났는지 알수있음
          // Widget Function(BuildContext, AsyncSnapshot<List<WebtoonModel>>
          if (snapshot.hasData) {
            return Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Expanded(
                  child: makeList(snapshot),
                  // makeList의 높이가 정의되지 않아 무한한값을 가졌으므로 Expanded로 제한을 정해준다.
                )
              ],
            );
            // extract method를 선택해서 메소드로 표현할수있다.
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

  ListView makeList(AsyncSnapshot<List<WebtoonModel>> snapshot) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      // 좌우로 스크롤
      itemCount: snapshot.data!.length,
      // webtoon의 크기
      itemBuilder: (context, index) {
        print(index);
        var webtoon = snapshot.data![index];
        // ListView Builder는 최적화 되어있는 ListView임, 사용자가 보고있는 아이템만 Build함
        // 사용자가 보고있지 않은 아이템은 메모리에서 삭제함
        // itemBuilder는 만들어야하는 아이템의 index(숫자, 위치)를 받음
        return Webtoon(
          title: webtoon.title,
          thumb: webtoon.thumb,
          id: webtoon.id,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(
        width: 40,
      ),
    );
  }
}
