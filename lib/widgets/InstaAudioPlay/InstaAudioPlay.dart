import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:awrad/widgets/InstaAudioPlay/InstaAudioVM.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class InstaAudioPlay extends StatefulWidget {
  final String url;
  final AssetsAudioPlayer player;
  const InstaAudioPlay({Key key, @required this.url, @required this.player})
      : super(key: key);

  @override
  _InstaAudioPlayState createState() => _InstaAudioPlayState();
}

class _InstaAudioPlayState extends State<InstaAudioPlay>
    with SingleTickerProviderStateMixin {
  AnimationController _ctrl;
  @override
  void initState() {
    _ctrl = AnimationController(
        vsync: this,
        duration: Duration(seconds: 5),
        lowerBound: 0.0,
        upperBound: 2 * pi)
      ..repeat();
    super.initState();
  }

  @override
  void dispose() {
    _ctrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<InstaAudioVM>.reactive(
      viewModelBuilder: () => InstaAudioVM(widget.url, widget.player),
      disposeViewModel: true,
      builder: (ctx, model, ch) {
        return model.hasError
            ? Icon(
                Icons.error,
                color: Colors.red,
              )
            : model.playingWidget(_ctrl);
      },
    );
  }
}
