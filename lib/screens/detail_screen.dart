import 'package:flu/models/webtoon_detail_model.dart';
import 'package:flu/models/webtoon_episode_model.dart';
import 'package:flu/services/api_service.dart';
import 'package:flu/widgets/episode_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  late SharedPreferences prefs;
  bool isLiked = false;
  // 초기화

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    // 핸드폰 저장소에 액세스 얻기
    final liked = prefs.getStringList('liked');
    // Liked의 String List 확인
    if (liked != null) {
      if (liked.contains(widget.id) == true) {
        // Liked의 String List가 있다면 해당 웹툰 ID를 가지고있는지 확인 (좋아요를 누른적이 있나?)
        setState(() {
          isLiked = true;
        });
        // 가지고 있다면 isLiked에 true 주기 (다시 들어가도 예전에 눌렀던 웹툰에 좋아요 유지)
      }
    } else {
      await prefs.setStringList('liked', []);
    }
  }
  // 사용자의 저장소에 connection을 만들어줄 method 만들기

  onLikedTap() async {
    final liked = prefs.getStringList('liked');
    // Liked의 String List 확인
    if (liked != null) {
      if (isLiked) {
        liked.remove(widget.id);
      } else {
        liked.add(widget.id);
      }
      await prefs.setStringList('liked', liked);
      // 좋아요를 눌럿건 안눌렀던간에 휴대폰에 다시 List(widget.id들을) 저장
      setState(() {
        isLiked = !isLiked;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    webtoon = ApiService.getToonById(widget.id);
    episodes = ApiService.getLastestEpisodesById(widget.id);
    initPrefs();
    // home screen은 id가 필요없었는데 detail은 id argument가 필요했음
    // 이 두(getToonById,getLastestEpisodesById) method는 widget의 ID를 전달받아야 하므로 StatefullWidget으로 바꿈
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black.withOpacity(0.5),
        actions: [
          IconButton(
            onPressed: onLikedTap,
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border_outlined,
            ),
          )
        ],
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            children: [
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
              const SizedBox(
                height: 30,
              ),
              FutureBuilder(
                future: webtoon,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data!.about,
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          '${snapshot.data!.genre} / ${snapshot.data!.age} ',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    );
                  }
                  return const Text('...');
                },
              ),
              const SizedBox(
                height: 25,
              ),
              FutureBuilder(
                future: episodes,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        for (var episode in snapshot.data!)
                          Episode(
                            episode: episode,
                            webtoonId: widget.id,
                          )
                      ],
                    );
                    // ListView는 최적화가 필요하고 필요요소가 굉장히 많을때 쓰면 좋음
                    // 간단한 작업일때에는 Column 만약 List의 길이를 몰랐다면 Listview가 맞는 선택일 수 있음
                  }
                  return Container();
                },
              )
            ],
          ),
        ),
      ),
    );
    // } https://comic.naver.com/webtoon/detail?titleId=$webtoonId&no=${episode.id}
  }
}
