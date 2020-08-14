import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:awrad/Consts/ConstMethodes.dart';
import 'package:awrad/Consts/ThemeCosts.dart';
import 'package:awrad/widgets/AudioPlayer/AudioVM.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class MyAudioPlayer extends StatefulWidget {
  final int pageNumber;
  final AssetsAudioPlayer player;
  const MyAudioPlayer(
      {Key key, @required this.pageNumber, @required this.player})
      : super(key: key);

  @override
  _MyAudioPlayerState createState() => _MyAudioPlayerState();
}

class _MyAudioPlayerState extends State<MyAudioPlayer>
    with SingleTickerProviderStateMixin {
  AnimationController ctrl;
  Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    ctrl =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _anim = Tween<double>(begin: 0, end: 1).animate(ctrl);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ViewModelBuilder<AudiVM>.reactive(
        viewModelBuilder: () => AudiVM(widget.pageNumber, widget.player),
        builder: (ctx, model, child) => Container(
          child: Flex(
            direction: Axis.vertical,
            children: <Widget>[
              model.player.builderCurrent(
                builder: (context, playing) {
                  if (playing == null) return Text("");
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            " ${model.getSurahName} الآية  ${model.getAyahName}"),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          DropdownButton(
                            items: model.items,
                            value: model.reader,
                            isDense: true,
                            icon: Icon(Icons.arrow_drop_up),
                            onChanged: model.changeReader,
                          ),
                          Text("بصوت"),
                        ],
                      )
                    ],
                  );
                },
              ),
              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.skip_previous),
                        onPressed: model.prev,
                      ),
                      IconButton(
                        icon: Icon(Icons.fast_rewind),
                        onPressed: model.slower,
                      ),
                      model.player.builderPlayerState(
                        builder: (context, data) {
                          final isPlaying = data == PlayerState.play;
                          _animate(isPlaying);
                          return AnimatedBuilder(
                            animation: _anim,
                            builder: (context, child) => InkWell(
                              onTap: () {
                                model.player.playOrPause();
                              },
                              child: AnimatedIcon(
                                size: 40,
                                icon: AnimatedIcons.play_pause,
                                progress: _anim,
                              ),
                            ),
                          );
                        },
                      ),
                      RotatedBox(
                          quarterTurns: 2,
                          child: IconButton(
                            icon: Icon(Icons.fast_rewind),
                            onPressed: model.faster,
                          )),
                      IconButton(
                        icon: Icon(Icons.skip_next),
                        onPressed: model.next,
                      )
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Container(
                  child: model.player.builderRealtimePlayingInfos(
                    builder: (context, data) {
                      double pre = getProgress(data);
                      return Column(
                        children: <Widget>[
                          LinearProgressIndicator(
                            backgroundColor: AppColors.adanActive,
                            value: data == null ? 0.0 : pre,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(data == null
                                  ? "00:00"
                                  : _formatedDate(data.currentPosition)),
                              Text(data == null
                                  ? "00:00"
                                  : _formatedDate(data.duration)),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _formatedDate(Duration dur) {
    final value = dur.inSeconds;
    final int minutes = value ~/ 60;
    final int second = value % 60;
    return '${minutes.toString().padLeft(2, "0")}:${second.toString().padLeft(2, "0")}';
  }

  _animate(bool isPlaying) {
    if (isPlaying) {
      ctrl.forward();
    } else {
      ctrl.reverse();
    }
  }
}
