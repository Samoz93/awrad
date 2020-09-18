import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:awrad/models/AwradModel.dart';
import 'package:awrad/services/AwradService.dart';
import 'package:stacked/stacked.dart';

class AwradVM extends BaseViewModel {
  final AssetsAudioPlayer player = AssetsAudioPlayer.newPlayer();

  final ser = AwradService();
  int _selectedTile = 0;
  int get selectedTile => _selectedTile;
  set selectedTile(int val) {
    _selectedTile = val;
    notifyListeners();
  }

  List<WrdModel> _awrad;
  List<WrdModel> get awrad => _awrad;

  fetchData(String type) {
    runBusyFuture(_getData(type));
  }

  _getData(type) async {
    _awrad = await ser.allAwrad(type);
    return _awrad;
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  reportMissing(WrdModel wrd) {
    ser.reportMissingWrd(wrd);
  }
}
