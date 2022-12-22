import 'package:flu/models/webtoon.dart';
import 'package:flu/services/api_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  Future<List<WebtoonModel>> webtoons = ApiService.getToons();

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
            return const Text('There is data');
          }
          return const Text('Loading');
        },
      ),
    );
  }
}
