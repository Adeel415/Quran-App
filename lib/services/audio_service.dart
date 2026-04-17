import 'package:audioplayers/audioplayers.dart';
import '../utils/constants.dart';

enum AudioPlaybackState { idle, loading, playing, paused, error, completed }

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal() {
    _init();
  }

  final AudioPlayer _player = AudioPlayer();
  AudioPlaybackState _state = AudioPlaybackState.idle;
  int? _currentGlobalAyah;
  int? _currentSurahId;
  int? _currentAyahNumber;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  // Callbacks
  void Function(AudioPlaybackState)? onStateChanged;
  void Function(Duration position, Duration duration)? onPositionChanged;
  void Function()? onCompleted;

  AudioPlaybackState get state => _state;
  int? get currentGlobalAyah => _currentGlobalAyah;
  int? get currentSurahId => _currentSurahId;
  int? get currentAyahNumber => _currentAyahNumber;
  Duration get position => _position;
  Duration get duration => _duration;
  bool get isPlaying => _state == AudioPlaybackState.playing;
  bool get isLoading => _state == AudioPlaybackState.loading;

  void _init() {
    _player.onPlayerStateChanged.listen((state) {
      switch (state) {
        case PlayerState.playing:
          _setState(AudioPlaybackState.playing);
          break;
        case PlayerState.paused:
          _setState(AudioPlaybackState.paused);
          break;
        case PlayerState.stopped:
        case PlayerState.disposed:
          _setState(AudioPlaybackState.idle);
          break;
        case PlayerState.completed:
          _setState(AudioPlaybackState.completed);
          onCompleted?.call();
          break;
      }
    });

    _player.onPositionChanged.listen((pos) {
      _position = pos;
      onPositionChanged?.call(_position, _duration);
    });

    _player.onDurationChanged.listen((dur) {
      _duration = dur;
    });
  }

  void _setState(AudioPlaybackState s) {
    _state = s;
    onStateChanged?.call(s);
  }

  /// Play an Ayah by its global number (1-6236)
  Future<void> playAyah({
    required int surahId,
    required int ayahNumber,
    required int globalNumber,
    String? customAudioUrl,
  }) async {
    try {
      // Stop any currently playing audio
      if (_state == AudioPlaybackState.playing || _state == AudioPlaybackState.paused) {
        await _player.stop();
      }

      _setState(AudioPlaybackState.loading);
      _currentGlobalAyah = globalNumber;
      _currentSurahId = surahId;
      _currentAyahNumber = ayahNumber;
      _position = Duration.zero;
      _duration = Duration.zero;

      final url = customAudioUrl ?? AppConstants.ayahAudioUrl(globalNumber);
      await _player.play(UrlSource(url));
    } catch (e) {
      _setState(AudioPlaybackState.error);
    }
  }

  Future<void> pause() async {
    if (_state == AudioPlaybackState.playing) {
      await _player.pause();
    }
  }

  Future<void> resume() async {
    if (_state == AudioPlaybackState.paused) {
      await _player.resume();
    }
  }

  Future<void> togglePlayPause({
    required int surahId,
    required int ayahNumber,
    required int globalNumber,
    String? customAudioUrl,
  }) async {
    if (_currentGlobalAyah == globalNumber) {
      if (_state == AudioPlaybackState.playing) {
        await pause();
      } else if (_state == AudioPlaybackState.paused) {
        await resume();
      } else {
        await playAyah(
          surahId: surahId,
          ayahNumber: ayahNumber,
          globalNumber: globalNumber,
          customAudioUrl: customAudioUrl,
        );
      }
    } else {
      await playAyah(
        surahId: surahId,
        ayahNumber: ayahNumber,
        globalNumber: globalNumber,
        customAudioUrl: customAudioUrl,
      );
    }
  }

  Future<void> stop() async {
    await _player.stop();
    _currentGlobalAyah = null;
    _currentSurahId = null;
    _currentAyahNumber = null;
    _setState(AudioPlaybackState.idle);
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  bool isCurrentAyah(int surahId, int ayahNumber) =>
      _currentSurahId == surahId && _currentAyahNumber == ayahNumber;

  void dispose() {
    _player.dispose();
  }
}
