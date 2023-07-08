import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_gem/controllers/player_controllar.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../consts/colors.dart';
import '../consts/text_style.dart';


class Player extends StatelessWidget {
  final List<SongModel> data;
  const Player({super.key, required this.data});

  @override
  Widget build(BuildContext context) {

    var controllar = Get.find<PlayerController>();
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0,),
        child: Column(
          children: [
            Obx( () =>
              Expanded(
                child: Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  height: 300,
                  width: 300,
                  decoration: const BoxDecoration(shape: BoxShape.circle,),
                  alignment: Alignment.center,
                  child: QueryArtworkWidget(id: data[controllar.playIndex.value].id, type: ArtworkType.AUDIO,
                  artworkHeight: double.infinity,
                  artworkWidth: double.infinity,
                  nullArtworkWidget: const Icon(Icons.music_note, size:48, color: whiteColor),
                  ),
                  ),),
            ),
                const SizedBox(height: 12,),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(8),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16),
                ),
              ),
              child: Obx(() =>
                Column(
                  children: [
                    const SizedBox(height: 12,),
                    Text(data[controllar.playIndex.value].displayNameWOExt,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: ourStyle(
                      color: bgDarkColor,
                      family: bold,
                      size: 25
                    ),
                    ),
                  const SizedBox(height: 6,),
                    Text(data[controllar.playIndex.value].artist.toString(),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: ourStyle(
                      color: bgDarkColor,
                      family: regular,
                      size: 20,
                    ),
                    ),
                   const SizedBox(height: 12,
                   ),
                   Obx( 
                    () => Row(
                      children: [Text(
                        controllar.position.value, style: ourStyle(
                        color: bgDarkColor
                      ),),
                      Expanded(child: Slider(
                        thumbColor: sliderColor,
                        inactiveColor: bgColor,
                        activeColor: sliderColor,
                        min: const Duration(seconds: 0).inSeconds.toDouble(),
                        max: controllar.max.value,
                        value: controllar.value.value, onChanged: (
                          newValue){
                            controllar.changeDurationToSeconds(newValue.toInt());
                            newValue = newValue;
                          },
                          ),
                        ),
                      Text(controllar.duration.value, style: ourStyle(
                        color: bgDarkColor
                      ),),
                      ],
                     ),
                   ),
                   const SizedBox(height: 12,),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children:[
                    IconButton(onPressed: (){
                      controllar.playSong(data[controllar.playIndex.value-1].uri, controllar.playIndex.value-1);
                    }, icon: const Icon(Icons.skip_previous_rounded, size: 40, color: bgDarkColor,
                    )),
                    Obx(
                      () => CircleAvatar(
                        radius: 35,
                        backgroundColor: bgDarkColor,
                        child: Transform.scale(
                          scale: 2.5,
                          child: IconButton(onPressed: (){
                            if(controllar.isPlaying.value) {
                              controllar.audioPlayer.pause();
                              controllar.isPlaying(false);
                            }else{
                              controllar.audioPlayer.play();
                              controllar.isPlaying(true);
                            }
                          }, icon: controllar.isPlaying.value ? const Icon(
                            Icons.pause, color: whiteColor,
                          ) :const Icon(Icons.play_arrow_rounded, color: whiteColor,
                          )),
                          ),
                          ),
                    ),
                    IconButton(onPressed: (){
                                          controllar.playSong(data[controllar.playIndex.value+1].uri, controllar.playIndex.value+1);
                    }, icon: const Icon(Icons.skip_previous_rounded, size: 40, color: bgDarkColor,
                               ),
                          ),
                        ],
                      ),
                    ],
                    ),
              ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
