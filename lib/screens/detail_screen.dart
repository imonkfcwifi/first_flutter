import 'package:flu/models/webtoon_detail_model.dart';
import 'package:flu/models/webtoon_episode_model.dart';
import 'package:flu/services/api_service.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  final String title, thumb, id;

  const DetailScreen({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<WebtoonDetailModel> webtoon;
  late Future<List<WebtoonEpisodeModel>> episodes;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    webtoon = ApiService.getToonById(widget.id);
    episodes = ApiService.getLastestEpisodesById(widget.id);
    // home screen은 id가 필요없었는데 detail은 id argument가 필요했음
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black.withOpacity(0.5),
        title: Text(
          widget.title,
          // 부모에게 가르는 의미 widget! (이 경우엔 DetailScreen과 statefulwidget)
          // 우리는 State를 extend 하는 class에 있지만 data는 DetailScreen의 statefulwidget에서 오기때문이다
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: widget.id,
                child: Container(
                  width: 250,
                  clipBehavior: Clip.hardEdge,
                  // 자식의 부모영역 침범 ClipBehavior
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 7,
                        offset: const Offset(10, 10),
                        // 그림자 위치 offset, center
                        color: Colors.black.withOpacity(0.3),
                      )
                    ],
                  ),
                  child: Image.network(widget.thumb),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
