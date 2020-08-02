import 'package:awrad/widgets/InstaAudioPlay/InstaAudioVM.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class InstaAudioPlay extends StatefulWidget {
  final String url;
  const InstaAudioPlay({Key key, @required this.url}) : super(key: key);

  @override
  _InstaAudioPlayState createState() => _InstaAudioPlayState();
}

class _InstaAudioPlayState extends State<InstaAudioPlay> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<InstaAudioVM>.reactive(
      viewModelBuilder: () => InstaAudioVM(widget.url),
      disposeViewModel: true,
      builder: (ctx, model, ch) {
        return model.playingWidget;
      },
    );
  }
}
