import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../consts/colors.dart';
import '../consts/text_style.dart';
import '../controllers/player_controllar.dart';
import 'player.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late PlayerController controller;
  @override
  void initState() {
    controller = Get.put(PlayerController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgDarkColor,
        appBar: AppBar(
          backgroundColor: bgDarkColor,
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.search,
                  color: whiteColor,
                ))
          ],
          leading: const Icon(
            Icons.sort_rounded,
            color: whiteColor,
          ),
          title: Text(
            "Swoofy",
            style: ourStyle(
              family: 'bold',
              size: 18,
            ),
          ),
        ),
        body: FutureBuilder<List<SongModel>>(
          future: controller.getSongsList(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  "No song found",
                  style: ourStyle(),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      child: Obx(
                            () => ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          tileColor: bgColor,
                          title: Text(
                            snapshot.data![index].displaynameWOExt,
                            style: ourStyle(family: bold, size: 15),
                          ),
                          subtitle: Text(
                            "${snapshot.data![index].artist}",
                            style: ourStyle(family: regular, size: 12),
                          ),
                          leading: QueryArtworkWidget(
                            id: snapshot.data![index].id,
                            type: ArtworkType.AUDIO,
                            nullArtworkWidget: const Icon(
                              Icons.music_note,
                              color: whiteColor,
                              size: 32,
                            ),
                          ),
                          trailing: controller.playIndex.value == index &&
                              controller.isPlaying.value
                              ? const Icon(Icons.play_arrow,
                              color: whiteColor, size: 26)
                              : null,
                          onTap: () {
                            Get.to(
                                    () => Player(
                                  data: snapshot.data!,
                                ),
                                transition: Transition.downToUp);
                            controller.playSong(
                                snapshot.data![index].uri, index);
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ));
  }
}
