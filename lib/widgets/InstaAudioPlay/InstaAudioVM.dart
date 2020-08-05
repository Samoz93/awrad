import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:awrad/Consts/ThemeCosts.dart';
import 'package:awrad/widgets/LoadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class InstaAudioVM extends BaseViewModel {
  final String url;
  final AssetsAudioPlayer player = AssetsAudioPlayer.newPlayer();

  InstaAudioVM(this.url);

  Widget playingWidget(AnimationController ctrl) {
    return player.builderRealtimePlayingInfos(
      builder: (context, info) {
        if (info == null || info.current == null)
          return getidleIcon(info, ctrl);
        if (info.isBuffering) return LoadingWidget();
        return getidleIcon(info, ctrl);
      },
    );
  }

  Widget getidleIcon(RealtimePlayingInfos info, AnimationController ctrl) {
    bool isPlaying = info == null ? false : info.isPlaying;
    bool hasData = info == null ? false : info.current != null;
    double currentProgress = info == null
        ? 0.0
        : info.current == null
            ? 0.0
            : info.currentPosition.inSeconds / info.duration.inSeconds;

    if (!isPlaying) {
      ctrl.value = 0.0;
      ctrl.stop();
    } else
      ctrl.repeat();
    return InkWell(
      child: Container(
        height: 30,
        width: 30,
        child: Stack(
          children: <Widget>[
            Center(
              child: CircularProgressIndicator(
                value: currentProgress,
                backgroundColor: AppColors.addColor,
              ),
            ),
            Center(
              child: AnimatedBuilder(
                animation: ctrl,
                builder: (context, ch) => Transform.rotate(
                  angle: ctrl.value,
                  child: ch,
                ),
                child: Icon(
                  isPlaying ? Icons.stop : Icons.play_arrow,
                  color: AppColors.addColor,
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        !hasData ? open() : isPlaying ? player.pause() : player.play();
      },
    );
  }

  open() async {
    try {
      setBusy(true);
      await this.player.open(Audio.network(url));
      setBusy(false);
    } catch (e) {
      setError(e.toString());
    }
  }

  @override
  void dispose() {
    // player.stop();
    player?.dispose();
    super.dispose();
  }
}
