import 'package:flutter/foundation.dart';
import '../services/audio_service.dart';

class AudioProvider extends ChangeNotifier {
  final AudioService _audioService = AudioService();

  AudioPlaybackState _state = AudioPlaybackState.idle;
  int? _currentSurahId;
  int? _currentAyahNumber;
  int? _currentGlobalNumber;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  AudioPlaybackState get state => _state;
  int? get currentSurahId => _currentSurahId;
  int? get currentAyahNumber => _currentAyahNumber;
  int? get currentGlobalNumber => _currentGlobalNumber;
  Duration get position => _position;
  Duration get duration => _duration;
  bool get isPlaying => _state == AudioPlaybackState.playing;
  bool get isLoading => _state == AudioPlaybackState.loading;
  bool get hasActiveAudio => _currentAyahNumber != null;

  double get progress {
    if (_duration.inMilliseconds == 0) return 0.0;
    return (_position.inMilliseconds / _duration.inMilliseconds).clamp(0.0, 1.0);
  }

  AudioProvider() {
    _audioService.onStateChanged = (state) {
      _state = state;
      if (state == AudioPlaybackState.completed || state == AudioPlaybackState.idle) {
        _currentSurahId = null;
        _currentAyahNumber = null;
        _currentGlobalNumber = null;
      }
      notifyListeners();
    };

    _audioService.onPositionChanged = (position, duration) {
      _position = position;
      _duration = duration;
      notifyListeners();
    };
  }

  bool isCurrentAyah(int surahId, int ayahNumber) {
    return _currentSurahId == surahId && _currentAyahNumber == ayahNumber;
  }

  Future<void> playAyah({
    required int surahId,
    required int ayahNumber,
    required int globalNumber,
    String? audioUrl,
  }) async {
    _currentSurahId = surahId;
    _currentAyahNumber = ayahNumber;
    _currentGlobalNumber = globalNumber;
    _state = AudioPlaybackState.loading;
    notifyListeners();

    await _audioService.togglePlayPause(
      surahId: surahId,
      ayahNumber: ayahNumber,
      globalNumber: globalNumber,
      customAudioUrl: audioUrl,
    );
  }

  Future<void> pause() async => _audioService.pause();
  Future<void> resume() async => _audioService.resume();
  Future<void> stop() async {
    await _audioService.stop();
    _currentSurahId = null;
    _currentAyahNumber = null;
    _currentGlobalNumber = null;
    notifyListeners();
  }

  Future<void> seek(Duration position) async => _audioService.seek(position);

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }
}
