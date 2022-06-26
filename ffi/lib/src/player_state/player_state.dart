// ignore_for_file: comment_references

import 'package:equatable/equatable.dart';

import '../media_source/media.dart';

/// State of a [Player] instance.
class CurrentState extends Equatable {
  const CurrentState({
    this.index,
    this.media,
    this.medias = const <Media>[],
    this.isPlaylist = false,
  });

  /// Index of currently playing [Media].
  final int? index;

  /// Currently playing [Media].
  final Media? media;

  /// [List] of [Media] currently opened in the [Player] instance.
  final List<Media> medias;

  /// Whether a [Playlist] is opened or a [Media].
  final bool isPlaylist;

  @override
  List<Object?> get props => [index, media, medias, isPlaylist];

  CurrentState copyWith({
    int? index,
    Media? media,
    List<Media>? medias,
    bool? isPlaylist,
  }) {
    return CurrentState(
      index: index ?? this.index,
      media: media ?? this.media,
      medias: medias ?? this.medias,
      isPlaylist: isPlaylist ?? this.isPlaylist,
    );
  }
}

/// Position & duration state of a [Player] instance.
class PositionState extends Equatable {
  const PositionState({
    this.position = Duration.zero,
    this.duration = Duration.zero,
  });

  /// Position of playback in [Duration] of currently playing [Media].
  final Duration position;

  /// Length of currently playing [Media] in [Duration].
  final Duration duration;

  @override
  List<Object?> get props => [position, duration];

  PositionState copyWith({
    Duration? position,
    Duration? duration,
  }) {
    return PositionState(
      position: position ?? this.position,
      duration: duration ?? this.duration,
    );
  }
}

/// Playback state of a [Player] instance.
class PlaybackState extends Equatable {
  const PlaybackState({
    this.isPlaying = false,
    this.isSeekable = true,
    this.isCompleted = false,
  });

  /// Whether [Player] instance is playing or not.
  final bool isPlaying;

  /// Whether [Player] instance is seekable or not.
  final bool isSeekable;

  /// Whether the current [Media] has ended playing or not.
  final bool isCompleted;

  @override
  List<Object?> get props => [isPlaying, isSeekable, isCompleted];

  PlaybackState copyWith({
    bool? isPlaying,
    bool? isSeekable,
    bool? isCompleted,
  }) {
    return PlaybackState(
      isPlaying: isPlaying ?? this.isPlaying,
      isSeekable: isSeekable ?? this.isSeekable,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

/// Volume & Rate state of a [Player] instance.
class GeneralState extends Equatable {
  const GeneralState({
    this.volume = 1,
    this.rate = 1,
  });

  /// Volume of [Player] instance.
  final double volume;

  /// Rate of playback of [Player] instance.
  final double rate;

  @override
  List<Object?> get props => [volume, rate];

  GeneralState copyWith({
    double? volume,
    double? rate,
  }) {
    return GeneralState(
      volume: volume ?? this.volume,
      rate: rate ?? this.rate,
    );
  }
}
